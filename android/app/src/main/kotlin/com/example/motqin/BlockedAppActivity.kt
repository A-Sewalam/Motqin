package com.example.motqin

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.os.CountDownTimer
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import kotlin.random.Random

/**
 * Unified "block" screen — pure native Kotlin UI (no Flutter engine involved).
 *
 * Shown in two situations:
 *  1. Right when a block session starts (launched from MainActivity).
 *  2. Whenever the user opens an app that's on the blocked list
 *     (launched from AppBlockerService).
 *
 * Shows a live countdown of time remaining, a motivational quote,
 * and a single button that opens the "allowed apps" quick launcher.
 */
class BlockedAppActivity : Activity() {

    companion object {
        const val EXTRA_BLOCKED_PKG = "blocked_pkg"
    }

    private var countDownTimer: CountDownTimer? = null
    private lateinit var timeText: TextView

    private val stateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val active = intent?.getBooleanExtra(AppBlockerService.EXTRA_ACTIVE, false) ?: false
            if (!active) {
                // Block was cancelled/expired elsewhere (e.g. admin override) — dismiss now.
                finishAndGoHome()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Safety net — never show the overlay over our own app.
        if (intent?.getStringExtra(EXTRA_BLOCKED_PKG) == packageName) {
            finishAndGoHome()
            return
        }

        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
            WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
        )

        setContentView(buildLayout())
        startCountdown()
    }

    override fun onStart() {
        super.onStart()
        val filter = IntentFilter(AppBlockerService.ACTION_BLOCK_STATE_CHANGED)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(stateReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(stateReceiver, filter)
        }
    }

    override fun onStop() {
        super.onStop()
        try {
            unregisterReceiver(stateReceiver)
        } catch (_: IllegalArgumentException) {
            // not registered — ignore
        }
    }

    override fun onDestroy() {
        countDownTimer?.cancel()
        super.onDestroy()
    }

    override fun onBackPressed() {
        finishAndGoHome()
    }

    // ── UI ──────────────────────────────────────────────────────────────

    private fun buildLayout(): View {
        val root = FrameLayout(this).apply {
            background = GradientDrawable(
                GradientDrawable.Orientation.TL_BR,
                intArrayOf(Color.parseColor("#60A8F0"), Color.parseColor("#2E6FE0"))
            )
        }

        val content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(64, 220, 64, 80)
        }

        timeText = TextView(this).apply {
            text = "00:00:00"
            textSize = 56f
            setTextColor(Color.WHITE)
            typeface = android.graphics.Typeface.DEFAULT_BOLD
            letterSpacing = 0.05f
            gravity = Gravity.CENTER
        }

        val timeLabel = TextView(this).apply {
            text = "الوقت المتبقي للحجب"
            textSize = 15f
            setTextColor(Color.parseColor("#E6FFFFFF"))
            gravity = Gravity.CENTER
            setPadding(0, 12, 0, 0)
        }

        val (quote, author) = pickRandomQuote()

        val quoteText = TextView(this).apply {
            text = quote
            textSize = 18f
            setTextColor(Color.parseColor("#F2FFFFFF"))
            gravity = Gravity.CENTER
            setLineSpacing(10f, 1.2f)
            setPadding(24, 0, 24, 0)
        }

        val authorText = TextView(this).apply {
            text = author
            textSize = 14f
            setTextColor(Color.parseColor("#CCFFFFFF"))
            gravity = Gravity.CENTER
            setPadding(0, 16, 0, 0)
        }

        val quoteSpacer = View(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT, 0, 1f
            )
        }

        val allowedAppsButton = buildGridButton()

        content.addView(timeText)
        content.addView(timeLabel)
        content.addView(spacer(48))
        content.addView(quoteText)
        content.addView(authorText)
        content.addView(quoteSpacer)
        content.addView(allowedAppsButton, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        ).apply { gravity = Gravity.CENTER_HORIZONTAL; bottomMargin = 24 })

        root.addView(content, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))

        return root
    }

    private fun spacer(heightDp: Int): View = View(this).apply {
        layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT, dp(heightDp)
        )
    }

    private fun dp(value: Int): Int =
        (value * resources.displayMetrics.density).toInt()

    /** Circular white button with a simple 3x3 dot-grid icon, drawn — no asset needed. */
    private fun buildGridButton(): View {
        val size = dp(64)
        val button = FrameLayout(this).apply {
            layoutParams = LinearLayout.LayoutParams(size, size)
            background = GradientDrawable().apply {
                shape = GradientDrawable.OVAL
                setColor(Color.WHITE)
            }
            isClickable = true
            isFocusable = true
            elevation = dp(4).toFloat()
        }

        val grid = GridDotsView(this)
        val dotsSize = dp(28)
        button.addView(grid, FrameLayout.LayoutParams(dotsSize, dotsSize).apply {
            gravity = Gravity.CENTER
        })

        button.setOnClickListener {
            startActivity(Intent(this, AllowedAppsActivity::class.java))
        }

        return button
    }

    private fun pickRandomQuote(): Pair<String, String> {
        val quotes = listOf(
            "النجاح هو نتيجة جهد صغير يتكرر يومًا بعد يوم" to "روبرت كولير",
            "لا تؤجل عمل اليوم إلى الغد، فالوقت لا يعود" to "مثل عربي",
            "التركيز هو فن قول لا للأشياء غير المهمة" to "ستيف جوبز",
            "النجاح ليس نهاية المطاف، والفشل ليس قاتلاً، الشجاعة للاستمرار هي ما يهم" to "ونستون تشرشل",
            "العقل الذي ينفتح على فكرة جديدة لن يعود إلى حجمه الأصلي أبدًا" to "ألبرت أينشتاين",
            "ابدأ من حيث أنت، استخدم ما لديك، وافعل ما تستطيع" to "آرثر آش"
        )
        return quotes[Random.nextInt(quotes.size)]
    }

    // ── Countdown ───────────────────────────────────────────────────────

    private fun startCountdown() {
        val endTime = AppBlockerService.getBlockEndTimeMillis(applicationContext)
        val remaining = endTime - System.currentTimeMillis()

        if (endTime <= 0L || remaining <= 0L) {
            // No active session (or already expired) — nothing to show, just leave.
            finishAndGoHome()
            return
        }

        countDownTimer?.cancel()
        countDownTimer = object : CountDownTimer(remaining, 1000L) {
            override fun onTick(millisUntilFinished: Long) {
                timeText.text = formatRemaining(millisUntilFinished)
            }

            override fun onFinish() {
                timeText.text = "00:00:00"
                // Bug 6: clear native block state so the Dart TimedBlockService
                // syncs correctly on next open, instead of racing with the Dart timer.
                AppBlockerService.setBlockActive(applicationContext, active = false)
                finishAndGoHome()
            }
        }.start()
    }

    private fun formatRemaining(millis: Long): String {
        val totalSeconds = millis / 1000
        val h = totalSeconds / 3600
        val m = (totalSeconds % 3600) / 60
        val s = totalSeconds % 60
        return String.format("%02d:%02d:%02d", h, m, s)
    }

    private fun finishAndGoHome() {
        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(homeIntent)
        finish()
    }
}

/** Tiny custom view that draws a 3x3 dot grid — stands in for an "apps" icon
 *  without needing a vector drawable asset. */
private class GridDotsView(context: Context) : View(context) {
    private val paint = android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#2E6FE0")
        style = android.graphics.Paint.Style.FILL
    }

    override fun onDraw(canvas: android.graphics.Canvas) {
        super.onDraw(canvas)
        val cols = 3
        val rows = 3
        val cellW = width.toFloat() / cols
        val cellH = height.toFloat() / rows
        val radius = minOf(cellW, cellH) / 5f

        for (row in 0 until rows) {
            for (col in 0 until cols) {
                val cx = cellW * col + cellW / 2f
                val cy = cellH * row + cellH / 2f
                canvas.drawCircle(cx, cy, radius, paint)
            }
        }
    }
}

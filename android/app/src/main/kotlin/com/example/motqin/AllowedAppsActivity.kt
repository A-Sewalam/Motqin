package com.example.motqin

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.BaseAdapter
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.GridView
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Quick "Allowed Apps" launcher.
 *
 * Lists every launchable app on the device that is NOT in the current
 * blocked-packages set. Tapping an app launches it immediately.
 */
class AllowedAppsActivity : Activity() {

    private data class AppEntry(
        val label: String,
        val packageName: String,
        val icon: Drawable
    )

    private var allApps: List<AppEntry> = emptyList()
    private lateinit var adapter: AppsAdapter
    private lateinit var gridView: GridView
    private lateinit var emptyText: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(buildLayout())
        loadAllowedApps()
    }

    // ── Data ────────────────────────────────────────────────────────────

    private fun loadAllowedApps() {
        val blocked = AppBlockerService.getBlockedPackages(applicationContext)
        val pm = packageManager

        val launcherIntent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val resolved = pm.queryIntentActivities(launcherIntent, 0)

        allApps = resolved
            .asSequence()
            .map { it.activityInfo }
            .filter { it.packageName != packageName } // hide Motqin itself
            .filter { it.packageName !in blocked }
            .distinctBy { it.packageName }
            .map { info ->
                AppEntry(
                    label = info.loadLabel(pm).toString(),
                    packageName = info.packageName,
                    icon = info.loadIcon(pm)
                )
            }
            .sortedBy { it.label.lowercase() }
            .toList()

        adapter = AppsAdapter(allApps)
        gridView.adapter = adapter
        updateEmptyState(allApps)
    }

    private fun updateEmptyState(list: List<AppEntry>) {
        emptyText.visibility = if (list.isEmpty()) View.VISIBLE else View.GONE
        gridView.visibility = if (list.isEmpty()) View.GONE else View.VISIBLE
    }

    private fun filter(query: String) {
        val q = query.trim().lowercase()
        val filtered = if (q.isEmpty()) allApps else allApps.filter {
            it.label.lowercase().contains(q)
        }
        adapter.updateList(filtered)
        updateEmptyState(filtered)
    }

    private fun launchApp(entry: AppEntry) {
        val launchIntent = packageManager.getLaunchIntentForPackage(entry.packageName)
        if (launchIntent != null) {
            launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            startActivity(launchIntent)
        }
        finish()
    }

    // ── UI ──────────────────────────────────────────────────────────────

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()

    private fun buildLayout(): View {
        val root = FrameLayout(this).apply {
            setBackgroundColor(Color.parseColor("#33000000"))
        }

        val sheet = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(Color.WHITE)
            setPadding(dp(20), dp(20), dp(20), dp(20))
        }

        // Header row: title + close button
        val header = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val title = TextView(this).apply {
            text = "التطبيقات المسموحة"
            textSize = 18f
            setTextColor(Color.parseColor("#222222"))
            typeface = android.graphics.Typeface.DEFAULT_BOLD
            layoutParams = LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f)
        }
        val closeBtn = ImageButton(this).apply {
            setImageDrawable(buildCloseIcon())
            background = null
            setOnClickListener { finish() }
        }
        header.addView(title)
        header.addView(closeBtn)

        // Search box
        val searchBox = EditText(this).apply {
            hint = "ابحث عن اسم التطبيق"
            textDirection = View.TEXT_DIRECTION_RTL
            gravity = Gravity.END
            setPadding(dp(16), dp(12), dp(16), dp(12))
            background = roundedDrawable("#F5F5F5", dp(12).toFloat())
            addTextChangedListener(object : TextWatcher {
                override fun beforeTextChanged(s: CharSequence?, a: Int, b: Int, c: Int) {}
                override fun onTextChanged(s: CharSequence?, a: Int, b: Int, c: Int) {}
                override fun afterTextChanged(s: Editable?) {
                    filter(s?.toString().orEmpty())
                }
            })
        }

        emptyText = TextView(this).apply {
            text = "لا توجد تطبيقات مسموحة مطابقة"
            gravity = Gravity.CENTER
            setTextColor(Color.GRAY)
            setPadding(0, dp(40), 0, dp(40))
            visibility = View.GONE
        }

        gridView = GridView(this).apply {
            numColumns = 5
            verticalSpacing = dp(16)
            horizontalSpacing = dp(8)
            setPadding(0, dp(16), 0, dp(16))
            clipToPadding = false
            onItemClickListener = AdapterView.OnItemClickListener { _, _, position, _ ->
                launchApp(this@AllowedAppsActivity.adapter.getItemAt(position))
            }
        }

        sheet.addView(header)
        sheet.addView(spacer(12))
        sheet.addView(searchBox)
        sheet.addView(emptyText)
        sheet.addView(gridView, LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f
        ))

        root.addView(sheet, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))

        return root
    }

    private fun spacer(heightDp: Int): View = View(this).apply {
        layoutParams = LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, dp(heightDp))
    }

    private fun roundedDrawable(colorHex: String, radius: Float): Drawable {
        return android.graphics.drawable.GradientDrawable().apply {
            setColor(Color.parseColor(colorHex))
            cornerRadius = radius
        }
    }

    private fun buildCloseIcon(): Drawable {
        // Simple programmatic "X" using a vector-free bitmap drawable would need more code;
        // reuse the platform's built-in close icon to avoid adding an asset.
        return resources.getDrawable(android.R.drawable.ic_menu_close_clear_cancel, theme)
    }

    // ── Adapter ─────────────────────────────────────────────────────────

    private inner class AppsAdapter(initial: List<AppEntry>) : BaseAdapter() {
        private var items: List<AppEntry> = initial

        fun updateList(newItems: List<AppEntry>) {
            items = newItems
            notifyDataSetChanged()
        }

        fun getItemAt(position: Int): AppEntry = items[position]

        override fun getCount(): Int = items.size
        override fun getItem(position: Int): Any = items[position]
        override fun getItemId(position: Int): Long = position.toLong()

        override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
            val entry = items[position]
            val container = LinearLayout(this@AllowedAppsActivity).apply {
                orientation = LinearLayout.VERTICAL
                gravity = Gravity.CENTER
                setPadding(dp(4), dp(4), dp(4), dp(4))
            }
            val iconView = ImageView(this@AllowedAppsActivity).apply {
                setImageDrawable(entry.icon)
                layoutParams = LinearLayout.LayoutParams(dp(48), dp(48))
            }
            val labelView = TextView(this@AllowedAppsActivity).apply {
                text = entry.label
                textSize = 11f
                maxLines = 1
                ellipsize = android.text.TextUtils.TruncateAt.END
                gravity = Gravity.CENTER
                setTextColor(Color.parseColor("#444444"))
                setPadding(0, dp(4), 0, 0)
            }
            container.addView(iconView)
            container.addView(labelView)
            return container
        }
    }
}

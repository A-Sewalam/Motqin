package com.example.motqin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView

class BlockedAppActivity : Activity() {

    companion object {
        const val EXTRA_BLOCKED_PKG = "blocked_pkg"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
        )

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(0xFF0F0F1A.toInt())
            setPadding(80, 80, 80, 80)
        }

        val shieldEmoji = TextView(this).apply {
            text = "🛡️"
            textSize = 64f
            gravity = Gravity.CENTER
        }

        val titleText = TextView(this).apply {
            text = "هذا التطبيق محجوب"
            textSize = 26f
            setTextColor(0xFFFFFFFF.toInt())
            gravity = Gravity.CENTER
            typeface = android.graphics.Typeface.DEFAULT_BOLD
            setPadding(0, 40, 0, 16)
        }

        val subText = TextView(this).apply {
            text = "أنت في وضع التركيز. لقد حجبت هذا التطبيق لنفسك\nاكمل مهامك أولاً 💪"
            textSize = 16f
            setTextColor(0xFFAAAAAA.toInt())
            gravity = Gravity.CENTER
            setPadding(0, 0, 0, 48)
        }

        val homeBtn = Button(this).apply {
            text = "العودة إلى الرئيسية"
            textSize = 16f
            setTextColor(0xFFFFFFFF.toInt())
            setBackgroundColor(0xFF2563EB.toInt())
            setPadding(60, 30, 60, 30)
            setOnClickListener { goHome() }
        }

        root.addView(shieldEmoji)
        root.addView(titleText)
        root.addView(subText)
        root.addView(homeBtn)

        setContentView(root)
    }

    override fun onBackPressed() {
        goHome()
    }

    private fun goHome() {
        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(homeIntent)
        finish()
    }
}

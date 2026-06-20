package com.example.motqin

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class AppBlockerService : AccessibilityService() {

    companion object {
        private const val TAG = "AppBlockerService"
        private const val PREFS_NAME = "app_blocker_prefs"
        private const val KEY_IS_ACTIVE = "is_block_active"
        private const val KEY_PACKAGES = "blocked_packages"
        private const val KEY_END_TIME = "block_end_time_millis"

        const val ACTION_BLOCK_STATE_CHANGED = "com.example.motqin.BLOCK_STATE_CHANGED"
        const val EXTRA_ACTIVE = "active"

        /** Packages that should NEVER be blocked regardless of user selection. */
        private val SYSTEM_EXEMPT = setOf(
            // Our own app
            "com.example.motqin",
            // Android system UI
            "com.android.systemui",
            // Common launchers — so the home screen is never blocked
            "com.android.launcher",
            "com.android.launcher2",
            "com.android.launcher3",
            "com.google.android.apps.nexuslauncher",   // Pixel
            "com.sec.android.app.launcher",             // Samsung One UI
            "com.miui.home",                            // Xiaomi MIUI
            "com.huawei.android.launcher",              // Huawei
            "com.oppo.launcher",                        // OPPO
            "com.vivo.launcher",                        // Vivo
            "com.bbk.launcher2",                        // BBK / iQOO
            // Block-overlay and allowed-apps activities (our own)
            "com.example.motqin.BlockedAppActivity",
            "com.example.motqin.AllowedAppsActivity",
        )

        fun setBlockActive(
            context: Context,
            active: Boolean,
            packages: Set<String> = emptySet(),
            endTimeMillis: Long = 0L
        ) {
            Log.d(TAG, "setBlockActive: active=$active packages=$packages endTime=$endTimeMillis")
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit().apply {
                putBoolean(KEY_IS_ACTIVE, active)
                // Always strip exempt packages before persisting
                putStringSet(KEY_PACKAGES, packages - SYSTEM_EXEMPT)
                putLong(KEY_END_TIME, if (active) endTimeMillis else 0L)
                apply()
            }
            context.sendBroadcast(Intent(ACTION_BLOCK_STATE_CHANGED).apply {
                putExtra(EXTRA_ACTIVE, active)
                setPackage(context.packageName)
            })
        }

        fun isBlockActive(context: Context): Boolean =
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getBoolean(KEY_IS_ACTIVE, false)

        fun getBlockedPackages(context: Context): Set<String> =
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getStringSet(KEY_PACKAGES, emptySet()) ?: emptySet()

        fun getBlockEndTimeMillis(context: Context): Long =
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getLong(KEY_END_TIME, 0L)
    }

    override fun onServiceConnected() {
        Log.d(TAG, "✅ AppBlockerService connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val pkg = event.packageName?.toString() ?: return

        // Always ignore our own app and system packages
        if (pkg == packageName) return
        if (pkg in SYSTEM_EXEMPT) return

        val isActive = isBlockActive(applicationContext)
        if (!isActive) return

        val blocked = getBlockedPackages(applicationContext)

        Log.d(TAG, "Window → pkg=$pkg | blocked=${pkg in blocked}")

        if (pkg in blocked) {
            Log.d(TAG, "🚫 BLOCKING $pkg")
            launchBlockedScreen(pkg)
        }
    }

    override fun onInterrupt() {
        Log.d(TAG, "onInterrupt")
    }

    private fun launchBlockedScreen(blockedPkg: String) {
        val intent = Intent(this, BlockedAppActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra(BlockedAppActivity.EXTRA_BLOCKED_PKG, blockedPkg)
        }
        startActivity(intent)
    }
}

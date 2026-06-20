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

        /** Broadcast fired whenever the block is turned on/off, so any open
         *  BlockedAppActivity can react immediately (e.g. dismiss itself). */
        const val ACTION_BLOCK_STATE_CHANGED = "com.example.motqin.BLOCK_STATE_CHANGED"
        const val EXTRA_ACTIVE = "active"

        fun setBlockActive(
            context: Context,
            active: Boolean,
            packages: Set<String> = emptySet(),
            endTimeMillis: Long = 0L
        ) {
            Log.d(TAG, "setBlockActive called: active=$active, packages=$packages, endTime=$endTimeMillis")
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit().apply {
                putBoolean(KEY_IS_ACTIVE, active)
                putStringSet(KEY_PACKAGES, packages)
                putLong(KEY_END_TIME, if (active) endTimeMillis else 0L)
                apply()
            }

            // Let any visible BlockedAppActivity know right away (e.g. admin cancelled,
            // or the timer expired on the Flutter side).
            context.sendBroadcast(Intent(ACTION_BLOCK_STATE_CHANGED).apply {
                putExtra(EXTRA_ACTIVE, active)
                setPackage(context.packageName)
            })
        }

        fun isBlockActive(context: Context): Boolean {
            return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getBoolean(KEY_IS_ACTIVE, false)
        }

        fun getBlockedPackages(context: Context): Set<String> {
            return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getStringSet(KEY_PACKAGES, emptySet()) ?: emptySet()
        }

        /** Epoch millis when the active block ends, or 0L if no block is active. */
        fun getBlockEndTimeMillis(context: Context): Long {
            return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getLong(KEY_END_TIME, 0L)
        }
    }

    override fun onServiceConnected() {
        Log.d(TAG, "✅ AppBlockerService connected successfully")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val pkg = event.packageName?.toString() ?: return
        val isActive = isBlockActive(applicationContext)
        val blocked = getBlockedPackages(applicationContext)

        Log.d(TAG, "Window changed → pkg=$pkg | blockActive=$isActive | blockedList=$blocked")

        if (!isActive) return
        if (pkg == packageName || pkg == "com.android.systemui") return

        if (pkg in blocked) {
            Log.d(TAG, "🚫 BLOCKING: $pkg — launching BlockedAppActivity")
            launchBlockedScreen(pkg)
        }
    }

    override fun onInterrupt() {
        Log.d(TAG, "onInterrupt called")
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

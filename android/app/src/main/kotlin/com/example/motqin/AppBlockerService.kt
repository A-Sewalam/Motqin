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

        fun setBlockActive(context: Context, active: Boolean, packages: Set<String> = emptySet()) {
            Log.d(TAG, "setBlockActive called: active=$active, packages=$packages")
            context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE).edit().apply {
                putBoolean(KEY_IS_ACTIVE, active)
                putStringSet(KEY_PACKAGES, packages)
                apply()
            }
        }

        fun isBlockActive(context: Context): Boolean {
            return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getBoolean(KEY_IS_ACTIVE, false)
        }

        fun getBlockedPackages(context: Context): Set<String> {
            return context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getStringSet(KEY_PACKAGES, emptySet()) ?: emptySet()
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

        // Log every foreground app change so we can see what's happening
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

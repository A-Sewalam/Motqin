package com.example.motqin

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * DeviceAdminReceiver
 *
 * Required to use DevicePolicyManager features like preventing uninstallation.
 * Must be registered in AndroidManifest.xml with BIND_DEVICE_ADMIN permission.
 */
class MotqinDeviceAdminReceiver : DeviceAdminReceiver() {

    companion object {
        private const val TAG = "MotqinDeviceAdmin"
    }

    override fun onEnabled(context: Context, intent: Intent) {
        Log.d(TAG, "✅ Device Admin enabled")
    }

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        // This message is shown to the user when they try to remove admin rights
        return "تعطيل صلاحيات المشرف سيسمح بحذف التطبيق وإلغاء حجب التطبيقات. هل أنت متأكد؟"
    }

    override fun onDisabled(context: Context, intent: Intent) {
        Log.d(TAG, "Device Admin disabled — block protection removed")
        // Clear the block state since protection is gone
        AppBlockerService.setBlockActive(context, active = false, packages = emptySet())
    }
}

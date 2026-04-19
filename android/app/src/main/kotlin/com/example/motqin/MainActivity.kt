package com.example.motqin

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        const val CHANNEL = "com.example.motqin/app_blocker"
        private const val TAG = "MainActivity"
        private const val REQUEST_CODE_ENABLE_ADMIN = 1001
    }

    private lateinit var devicePolicyManager: DevicePolicyManager
    private lateinit var adminComponent: ComponentName

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        devicePolicyManager =
            getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        adminComponent = ComponentName(this, MotqinDeviceAdminReceiver::class.java)

        Log.d(TAG, "✅ MethodChannel registered on: $CHANNEL")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                Log.d(TAG, "📲 MethodChannel call: ${call.method}")

                when (call.method) {

                    "isAccessibilityEnabled" -> {
                        result.success(isAccessibilityServiceEnabled())
                    }

                    "openAccessibilitySettings" -> {
                        startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                        result.success(null)
                    }

                    "startBlock" -> {
                        val packages = call.argument<List<String>>("packages")
                        if (packages == null) {
                            result.error("INVALID_ARGS", "packages list is required", null)
                            return@setMethodCallHandler
                        }
                        AppBlockerService.setBlockActive(
                            applicationContext,
                            active = true,
                            packages = packages.toSet()
                        )
                        Log.d(TAG, "✅ Block activated with packages: $packages")
                        result.success(null)
                    }

                    "stopBlock" -> {
                        AppBlockerService.setBlockActive(
                            applicationContext,
                            active = false,
                            packages = emptySet()
                        )
                        // Remove Device Admin so app can be uninstalled after timer ends
                        removeDeviceAdminIfActive()
                        Log.d(TAG, "✅ Block stopped, Device Admin removed")
                        result.success(null)
                    }

                    "isBlockActive" -> {
                        result.success(AppBlockerService.isBlockActive(applicationContext))
                    }

                    "isDeviceAdminActive" -> {
                        val active = devicePolicyManager.isAdminActive(adminComponent)
                        Log.d(TAG, "isDeviceAdminActive → $active")
                        result.success(active)
                    }

                    "requestDeviceAdmin" -> {
                        Log.d(TAG, "requestDeviceAdmin called")
                        requestDeviceAdmin()
                        result.success(null)
                    }

                    "syncBlockState" -> {
                        val blockActive = AppBlockerService.isBlockActive(applicationContext)
                        if (!blockActive) {
                            removeDeviceAdminIfActive()
                            Log.d(TAG, "syncBlockState: cleaned up stale Device Admin")
                        } else {
                            Log.d(TAG, "syncBlockState: block active, keeping Device Admin")
                        }
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun requestDeviceAdmin() {
        val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN).apply {
            putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, adminComponent)
            putExtra(
                DevicePolicyManager.EXTRA_ADD_EXPLANATION,
                "تفعيل هذا الإذن سيمنع حذف التطبيق أثناء جلسة الحجب لضمان الالتزام بوقت الدراسة"
            )
        }
        startActivityForResult(intent, REQUEST_CODE_ENABLE_ADMIN)
    }

    private fun removeDeviceAdminIfActive() {
        if (devicePolicyManager.isAdminActive(adminComponent)) {
            devicePolicyManager.removeActiveAdmin(adminComponent)
            Log.d(TAG, "Device Admin removed — app can be uninstalled normally")
        }
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val expectedComponent = "$packageName/${AppBlockerService::class.java.name}"
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        ) ?: return false

        return TextUtils.SimpleStringSplitter(':').apply {
            setString(enabledServices)
        }.any { it.equals(expectedComponent, ignoreCase = true) }
    }
}

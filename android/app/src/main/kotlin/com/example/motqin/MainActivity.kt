package com.example.motqin

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.provider.Settings
import android.text.TextUtils
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

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
                        // endTime is optional for backward compatibility, but required
                        // for the countdown screen to know when to stop.
                        val endTime = call.argument<Long>("endTime") ?: 0L

                        AppBlockerService.setBlockActive(
                            applicationContext,
                            active = true,
                            packages = packages.toSet(),
                            endTimeMillis = endTime
                        )
                        Log.d(TAG, "✅ Block activated with packages: $packages, endTime=$endTime")

                        // Show the block/countdown screen immediately.
                        startActivity(Intent(this, BlockedAppActivity::class.java).apply {
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        })

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

                    "getInstalledApps" -> {
                        Thread {
                            try {
                                val apps = getInstalledUserApps()
                                runOnUiThread { result.success(apps) }
                            } catch (e: Exception) {
                                runOnUiThread {
                                    result.error("GET_APPS_FAILED", e.message, null)
                                }
                            }
                        }.start()
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun getInstalledUserApps(): List<Map<String, String>> {
        val pm = packageManager
        val launchIntent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }
        val resolved = pm.queryIntentActivities(launchIntent, 0)

        return resolved
            .asSequence()
            .map { it.activityInfo }
            .filter { it.packageName != packageName }           // hide Motqin itself
            .filter { it.packageName != "com.android.launcher3" }
            .distinctBy { it.packageName }
            .sortedBy { it.loadLabel(pm).toString().lowercase() }
            .map { info ->
                val icon = try { drawableToBase64(info.loadIcon(pm)) } catch (_: Exception) { "" }
                mapOf(
                    "name"        to info.loadLabel(pm).toString(),
                    "packageName" to info.packageName,
                    "icon"        to icon,
                )
            }
            .toList()
    }

    private fun drawableToBase64(drawable: Drawable): String {
        val bitmap = if (drawable is BitmapDrawable && drawable.bitmap != null) {
            drawable.bitmap
        } else {
            val w = drawable.intrinsicWidth.takeIf { it > 0 } ?: 48
            val h = drawable.intrinsicHeight.takeIf { it > 0 } ?: 48
            val bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bmp)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bmp
        }
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 85, stream)
        return Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
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

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const List<String> kDefaultBlockedPackages = [
  'com.facebook.katana',
  'com.instagram.android',
  'com.zhiliaoapp.musically',
  'com.snapchat.android',
  'com.twitter.android',
  'com.google.android.youtube',
  'com.whatsapp',
  'org.telegram.messenger',
];

// ── Model ──────────────────────────────────────────────────────────────────

class InstalledApp {
  final String name;
  final String packageName;
  final String iconBase64;

  const InstalledApp({
    required this.name,
    required this.packageName,
    required this.iconBase64,
  });

  /// Decoded icon bytes — use with Image.memory(app.iconBytes)
  Uint8List get iconBytes => base64Decode(iconBase64);
}

// ── Channel ────────────────────────────────────────────────────────────────

class AppBlockChannel {
  static const _channel = MethodChannel('com.example.motqin/app_blocker');

  /// Returns every launchable user app installed on the device.
  /// Each app carries its name, package name, and a base64-encoded PNG icon.
  Future<List<InstalledApp>> getInstalledApps() async {
    try {
      final List<dynamic> raw =
          await _channel.invokeMethod<List<dynamic>>('getInstalledApps') ?? [];
      return raw
          .cast<Map<dynamic, dynamic>>()
          .map((m) => InstalledApp(
                name: m['name'] as String? ?? '',
                packageName: m['packageName'] as String? ?? '',
                iconBase64: m['icon'] as String? ?? '',
              ))
          .where((a) => a.packageName.isNotEmpty)
          .toList();
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] getInstalledApps failed: $e');
      return [];
    }
  }

  Future<bool> isAccessibilityEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isAccessibilityEnabled') ?? false;
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] isAccessibilityEnabled failed: $e');
      return false;
    }
  }

  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] openAccessibilitySettings failed: $e');
    }
  }

  /// [endTime] is required so the native countdown/block screen knows when
  /// the session ends. It's optional only for backward compatibility.
  Future<void> startBlock({List<String>? packages, DateTime? endTime}) async {
    try {
      await _channel.invokeMethod('startBlock', {
        'packages': packages ?? kDefaultBlockedPackages,
        'endTime': endTime?.millisecondsSinceEpoch ?? 0,
      });
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] startBlock failed: $e');
      rethrow;
    }
  }

  Future<void> stopBlock() async {
    try {
      await _channel.invokeMethod('stopBlock');
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] stopBlock failed: $e');
      rethrow;
    }
  }

  Future<bool> isBlockActive() async {
    try {
      return await _channel.invokeMethod<bool>('isBlockActive') ?? false;
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] isBlockActive failed: $e');
      return false;
    }
  }

  /// Tells native to sync its state — removes Device Admin if no block is active.
  Future<void> syncBlockState() async {
    try {
      await _channel.invokeMethod('syncBlockState');
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] syncBlockState failed: $e');
    }
  }

  Future<void> requestDeviceAdmin() async {
    try {
      await _channel.invokeMethod('requestDeviceAdmin');
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] requestDeviceAdmin failed: $e');
    }
  }

  Future<bool> isDeviceAdminActive() async {
    try {
      return await _channel.invokeMethod<bool>('isDeviceAdminActive') ?? false;
    } on PlatformException catch (e) {
      debugPrint('[AppBlockChannel] isDeviceAdminActive failed: $e');
      return false;
    }
  }
}

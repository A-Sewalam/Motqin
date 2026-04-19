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

class AppBlockChannel {
  static const _channel = MethodChannel('com.example.motqin/app_blocker');

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

  Future<void> startBlock({List<String>? packages}) async {
    try {
      await _channel.invokeMethod('startBlock', {
        'packages': packages ?? kDefaultBlockedPackages,
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

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_block_channel.dart';

enum BlockStatus { inactive, active, expired }

enum BlockMode {
  untilStudyPlanEnd,
  untilDateTime,
}

class BlockSession {
  final DateTime startTime;
  final DateTime endTime;
  final BlockMode mode;

  const BlockSession({
    required this.startTime,
    required this.endTime,
    required this.mode,
  });

  Duration get remaining => endTime.difference(DateTime.now());
  bool get isExpired => DateTime.now().isAfter(endTime);

  double get progressFraction {
    final total = endTime.difference(startTime).inSeconds;
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    if (total <= 0) return 1.0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String get formattedRemaining {
    final r = remaining;
    if (r.isNegative) return '00:00:00';
    final h = r.inHours.toString().padLeft(2, '0');
    final m = (r.inMinutes % 60).toString().padLeft(2, '0');
    final s = (r.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class TimedBlockService extends ChangeNotifier {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final TimedBlockService _instance = TimedBlockService._internal();
  factory TimedBlockService() => _instance;
  TimedBlockService._internal();

  static const _kStartTime = 'block_start_time';
  static const _kEndTime   = 'block_end_time';
  static const _kMode      = 'block_mode';
  static const _kIsActive  = 'block_is_active';

  final AppBlockChannel _native = AppBlockChannel();

  BlockSession? _session;
  Timer? _ticker;
  BlockStatus _status = BlockStatus.inactive;
  bool _initialized = false;

  List<String>? customPackages;

  BlockStatus get status => _status;
  BlockSession? get session => _session;
  bool get isActive => _status == BlockStatus.active;
  bool get isCancellable => false;

  // ── Permissions ────────────────────────────────────────────────────────────
  Future<bool> isPermissionGranted() => _native.isAccessibilityEnabled();
  Future<void> requestPermission() => _native.openAccessibilitySettings();
  Future<bool> isDeviceAdminActive() => _native.isDeviceAdminActive();
  Future<void> requestDeviceAdmin() => _native.requestDeviceAdmin();

  // ── Init: restores session from SharedPreferences ─────────────────────────
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final isActive = prefs.getBool(_kIsActive) ?? false;
    if (!isActive) {
      await _native.syncBlockState();
      return;
    }

    final startMs = prefs.getInt(_kStartTime);
    final endMs   = prefs.getInt(_kEndTime);
    final modeIdx = prefs.getInt(_kMode);

    if (startMs == null || endMs == null || modeIdx == null) {
      await _clearPrefs();
      await _native.syncBlockState();
      return;
    }

    final session = BlockSession(
      startTime: DateTime.fromMillisecondsSinceEpoch(startMs),
      endTime:   DateTime.fromMillisecondsSinceEpoch(endMs),
      mode:      BlockMode.values[modeIdx],
    );

    if (session.isExpired) {
      await _clearPrefs();
      await _native.stopBlock();
      _status = BlockStatus.inactive;
      notifyListeners();
      return;
    }

    _session = session;
    _status  = BlockStatus.active;
    _startTicker();
    notifyListeners();
  }

  // ── Start block ────────────────────────────────────────────────────────────
  Future<void> startBlock({
    required BlockMode mode,
    required DateTime endTime,
  }) async {
    if (_status == BlockStatus.active) throw StateError('Already active.');
    if (endTime.isBefore(DateTime.now())) throw ArgumentError('endTime must be future.');

    await _native.startBlock(packages: customPackages);

    _session = BlockSession(
        startTime: DateTime.now(), endTime: endTime, mode: mode);
    _status = BlockStatus.active;
    await _savePrefs(_session!);
    _startTicker();
    notifyListeners();
  }

  // ── Study plan completed ───────────────────────────────────────────────────
  Future<void> onStudyPlanCompleted() async {
    if (_status == BlockStatus.active &&
        _session?.mode == BlockMode.untilStudyPlanEnd) {
      await _expireBlock();
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────────
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_session != null && _session!.isExpired) {
        await _expireBlock();
      } else {
        notifyListeners();
      }
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> _expireBlock() async {
    _stopTicker();
    await _clearPrefs();
    await _native.stopBlock();
    _status = BlockStatus.expired;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () {
      if (_status == BlockStatus.expired) {
        _session = null;
        _status  = BlockStatus.inactive;
        notifyListeners();
      }
    });
  }

  Future<void> _savePrefs(BlockSession s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsActive,  true);
    await prefs.setInt(_kStartTime,  s.startTime.millisecondsSinceEpoch);
    await prefs.setInt(_kEndTime,    s.endTime.millisecondsSinceEpoch);
    await prefs.setInt(_kMode,       s.mode.index);
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kIsActive);
    await prefs.remove(_kStartTime);
    await prefs.remove(_kEndTime);
    await prefs.remove(_kMode);
  }

  @override
  void dispose() {
    // Singleton — intentionally not disposed
    super.dispose();
  }
}

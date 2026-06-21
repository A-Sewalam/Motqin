import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'restrict_app_usage_widget.dart';
import 'block_options_widget.dart';
import 'admin_settings_widget.dart';
import 'timed_block_service.dart';

class BlockDistractionsScreen extends StatefulWidget {
  const BlockDistractionsScreen({super.key});

  @override
  State<BlockDistractionsScreen> createState() =>
      _BlockDistractionsScreenState();
}

class _BlockDistractionsScreenState extends State<BlockDistractionsScreen> {
  bool _allBlocked = false;
  Set<String> _selectedPackages = {};

  // Permission state
  bool _permissionChecked = false;
  bool _permissionGranted = false;

  static const _kPermAsked        = 'accessibility_permission_asked';
  static const _kDeviceAdminAsked = 'device_admin_asked';
  static const _kOverlayAsked     = 'overlay_permission_asked';

  @override
  void initState() {
    super.initState();
    _checkPermissionOnce();
  }

  void _onToggleBlock(bool blocked) =>
      setState(() => _allBlocked = blocked);

  void _onPackagesChanged(Set<String> packages) =>
      setState(() => _selectedPackages = packages);

  // ── Permission logic ────────────────────────────────────────────────

  Future<void> _checkPermissionOnce() async {
    final service = TimedBlockService();
    final granted = await service.isPermissionGranted();

    if (granted) {
      // Accessibility granted — also request Device Admin + overlay once if not yet asked
      await _checkDeviceAdminOnce();
      await _checkOverlayPermissionOnce();
      if (mounted) setState(() { _permissionGranted = true; _permissionChecked = true; });
      return;
    }

    // Check if we've already asked before
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool(_kPermAsked) ?? false;

    if (!alreadyAsked) {
      // First time: show dialog after the frame renders
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showPermissionDialog();
      });
    }

    if (mounted) setState(() { _permissionGranted = false; _permissionChecked = true; });
  }

  Future<void> _showPermissionDialog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPermAsked, true);

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.security_outlined, color: Color(0xFF2563EB), size: 24),
              SizedBox(width: 10),
              Text(
                'إذن الوصول للتطبيقات',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'تحتاج هذه الميزة إلى تفعيل خدمة إمكانية الوصول حتى تتمكن من حجب التطبيقات أثناء الدراسة.\n\nاضغط "تفعيل" ثم ابحث عن "Motqin" وفعّل الخدمة.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'لاحقاً',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await TimedBlockService().requestPermission();
                if (mounted) {
                  await _checkDeviceAdminOnce();
                  await _checkOverlayPermissionOnce();
                  _recheckPermission();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('تفعيل', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkDeviceAdminOnce() async {
    final service = TimedBlockService();
    final alreadyActive = await service.isDeviceAdminActive();
    if (alreadyActive) return; // already granted, nothing to do

    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool(_kDeviceAdminAsked) ?? false;
    if (alreadyAsked) return; // asked before, don't ask again

    await prefs.setBool(_kDeviceAdminAsked, true);

    // Small delay so the accessibility settings screen closes first
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.admin_panel_settings_outlined,
                  color: Color(0xFF7C3AED), size: 24),
              SizedBox(width: 10),
              Text('حماية التطبيق',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'لمنع حذف التطبيق أثناء جلسة الحجب، نحتاج إذن مشرف الجهاز.\n\nهذا يضمن التزامك بوقت الدراسة.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('تخطي',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await TimedBlockService().requestDeviceAdmin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('تفعيل', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkOverlayPermissionOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked = prefs.getBool(_kOverlayAsked) ?? false;
    if (alreadyAsked) return;

    const channel = MethodChannel('com.example.motqin/app_blocker');
    final granted = await channel.invokeMethod<bool>('isOverlayPermissionGranted') ?? true;
    if (granted) return;

    await prefs.setBool(_kOverlayAsked, true);
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.layers_outlined, color: Color(0xFFEA580C), size: 24),
              SizedBox(width: 10),
              Text('إذن العرض فوق التطبيقات',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'لكي تظهر شاشة الحجب فوق التطبيقات الأخرى، نحتاج إذن "العرض فوق التطبيقات".\n\nاضغط تفعيل ثم فعّل الإذن لتطبيق Motqin.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('تخطي',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await channel.invokeMethod('requestOverlayPermission');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEA580C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('تفعيل', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _recheckPermission() async {
    final granted = await TimedBlockService().isPermissionGranted();
    if (mounted) setState(() => _permissionGranted = granted);
  }

  // ── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'منع المشتتات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.appbartitlesColor,
            ),
          ),
        ),
        body: !_permissionChecked
            // Still checking — show neutral loader, no red error
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF2563EB)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Permission banner — only shown if not yet granted
                    if (!_permissionGranted) ...[
                      _PermissionBanner(onTap: () async {
                        await TimedBlockService().requestPermission();
                        _recheckPermission();
                      }),
                      const SizedBox(height: 20),
                    ],
                    RestrictAppUsageWidget(
                      allBlocked: _allBlocked,
                      onPackagesChanged: _onPackagesChanged,
                    ),
                    const SizedBox(height: 20),
                    BlockOptionsWidget(
                      onToggleBlock: _onToggleBlock,
                      customPackages: _selectedPackages,
                    ),
                    const SizedBox(height: 20),
                    const AdminSettingsWidget(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

// ── Permission banner ─────────────────────────────────────────────────────────

class _PermissionBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PermissionBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEA580C), size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'يجب تفعيل خدمة إمكانية الوصول لحجب التطبيقات',
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFEA580C),
                  height: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFEA580C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('تفعيل', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

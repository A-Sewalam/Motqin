import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'restrict_app_usage_widget.dart';
import 'block_options_widget.dart';
import 'admin_settings_widget.dart';
import 'timed_block_service.dart';
// import 'block_prefs_keys.dart';

class BlockDistractionsScreen extends StatefulWidget {
  const BlockDistractionsScreen({super.key});

  @override
  State<BlockDistractionsScreen> createState() =>
      _BlockDistractionsScreenState();
}

class _BlockDistractionsScreenState extends State<BlockDistractionsScreen> {
  bool _allBlocked = false;
  Set<String> _selectedPackages = {};

  bool _permissionChecked = false;
  bool _accessibilityGranted = false;
  bool _deviceAdminGranted = false;
  bool _overlayGranted = false;

  static const _channel = MethodChannel('com.example.motqin/app_blocker');
  static const _kOnboardingShown = 'permissions_onboarding_shown';

  @override
  void initState() {
    super.initState();
    _init();
  }

  // ── Init ─────────────────────────────────────────────────────────────

  Future<void> _init() async {
    await _refreshPermissions();

    final prefs = await SharedPreferences.getInstance();
    final onboardingShown = prefs.getBool(_kOnboardingShown) ?? false;

    // Show the sheet on first open OR if any permission is still missing
    final allGranted =
        _accessibilityGranted && _deviceAdminGranted && _overlayGranted;

    if (!onboardingShown || !allGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showPermissionsSheet();
      });
    }

    if (mounted) setState(() => _permissionChecked = true);
  }

  Future<void> _refreshPermissions() async {
    final service = TimedBlockService();
    final accessibility = await service.isPermissionGranted();
    final admin = await service.isDeviceAdminActive();
    final overlay =
        await _channel.invokeMethod<bool>('isOverlayPermissionGranted') ?? true;

    if (mounted) {
      setState(() {
        _accessibilityGranted = accessibility;
        _deviceAdminGranted = admin;
        _overlayGranted = overlay;
      });
    }
  }

  void _onToggleBlock(bool blocked) =>
      setState(() => _allBlocked = blocked);

  void _onPackagesChanged(Set<String> packages) =>
      setState(() => _selectedPackages = packages);

  // ── Single permissions bottom sheet ──────────────────────────────────

  Future<void> _showPermissionsSheet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingShown, true);

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => _PermissionsSheet(
        accessibilityGranted: _accessibilityGranted,
        deviceAdminGranted: _deviceAdminGranted,
        overlayGranted: _overlayGranted,
        onRequestAccessibility: () async {
          await TimedBlockService().requestPermission();
          await _refreshPermissions();
        },
        onRequestDeviceAdmin: () async {
          await TimedBlockService().requestDeviceAdmin();
          await _refreshPermissions();
        },
        onRequestOverlay: () async {
          await _channel.invokeMethod('requestOverlayPermission');
          await _refreshPermissions();
        },
        onRefresh: _refreshPermissions,
      ),
    );

    // Re-check after sheet closes
    await _refreshPermissions();
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool anyMissing =
        !_accessibilityGranted || !_deviceAdminGranted || !_overlayGranted;

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
          // Settings icon to reopen the permissions sheet any time
          actions: [
            IconButton(
              icon: Icon(
                Icons.shield_outlined,
                color: anyMissing
                    ? const Color(0xFFEA580C)
                    : const Color(0xFF22C55E),
              ),
              tooltip: 'الأذونات',
              onPressed: _showPermissionsSheet,
            ),
          ],
        ),
        body: !_permissionChecked
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF2563EB)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Compact banner if accessibility is still missing
                    if (!_accessibilityGranted) ...[
                      _MissingPermissionBanner(
                          onTap: _showPermissionsSheet),
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

// ── Permissions bottom sheet ──────────────────────────────────────────────────

class _PermissionsSheet extends StatefulWidget {
  final bool accessibilityGranted;
  final bool deviceAdminGranted;
  final bool overlayGranted;
  final Future<void> Function() onRequestAccessibility;
  final Future<void> Function() onRequestDeviceAdmin;
  final Future<void> Function() onRequestOverlay;
  final Future<void> Function() onRefresh;

  const _PermissionsSheet({
    required this.accessibilityGranted,
    required this.deviceAdminGranted,
    required this.overlayGranted,
    required this.onRequestAccessibility,
    required this.onRequestDeviceAdmin,
    required this.onRequestOverlay,
    required this.onRefresh,
  });

  @override
  State<_PermissionsSheet> createState() => _PermissionsSheetState();
}

class _PermissionsSheetState extends State<_PermissionsSheet> {
  late bool _accessibilityGranted;
  late bool _deviceAdminGranted;
  late bool _overlayGranted;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _accessibilityGranted = widget.accessibilityGranted;
    _deviceAdminGranted = widget.deviceAdminGranted;
    _overlayGranted = widget.overlayGranted;
  }

  bool get _allGranted =>
      _accessibilityGranted && _deviceAdminGranted && _overlayGranted;

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await widget.onRefresh();
    // Re-read from service directly
    final service = TimedBlockService();
    final a = await service.isPermissionGranted();
    final d = await service.isDeviceAdminActive();
    const ch = MethodChannel('com.example.motqin/app_blocker');
    final o = await ch.invokeMethod<bool>('isOverlayPermissionGranted') ?? true;
    if (mounted) {
      setState(() {
        _accessibilityGranted = a;
        _deviceAdminGranted = d;
        _overlayGranted = o;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                const Icon(Icons.shield_outlined,
                    color: Color(0xFF2563EB), size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'الأذونات المطلوبة',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_loading)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF2563EB)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'تحتاج هذه الميزة إلى الأذونات التالية لتعمل بشكل صحيح',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Permission rows
            _PermissionRow(
              icon: Icons.accessibility_new_outlined,
              color: const Color(0xFF2563EB),
              title: 'خدمة إمكانية الوصول',
              subtitle: 'ضرورية لمراقبة التطبيقات وحجبها',
              granted: _accessibilityGranted,
              onToggle: () async {
                await widget.onRequestAccessibility();
                await _refresh();
              },
            ),
            const Divider(height: 24),
            _PermissionRow(
              icon: Icons.admin_panel_settings_outlined,
              color: const Color(0xFF7C3AED),
              title: 'مشرف الجهاز',
              subtitle: 'يمنع حذف التطبيق أثناء جلسة الحجب',
              granted: _deviceAdminGranted,
              onToggle: () async {
                await widget.onRequestDeviceAdmin();
                await _refresh();
              },
            ),
            const Divider(height: 24),
            _PermissionRow(
              icon: Icons.layers_outlined,
              color: const Color(0xFFEA580C),
              title: 'العرض فوق التطبيقات',
              subtitle: 'لإظهار شاشة الحجب فوق التطبيقات الأخرى',
              granted: _overlayGranted,
              onToggle: () async {
                await widget.onRequestOverlay();
                await _refresh();
              },
            ),
            const SizedBox(height: 24),

            // Refresh + Done buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('تحديث'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allGranted
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      _allGranted ? 'تم — كل الأذونات مفعلة' : 'إغلاق',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single permission row ─────────────────────────────────────────────────────

class _PermissionRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool granted;
  final VoidCallback onToggle;

  const _PermissionRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Toggle button
        GestureDetector(
          onTap: granted ? null : onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 64,
            height: 32,
            decoration: BoxDecoration(
              color: granted
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  alignment: granted
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        granted ? Icons.check : Icons.close,
                        size: 14,
                        color: granted
                            ? const Color(0xFF22C55E)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Compact banner shown if accessibility still missing ───────────────────────

class _MissingPermissionBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _MissingPermissionBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFED7AA), width: 1.5),
        ),
        child: Row(
          children: const [
            Icon(Icons.warning_amber_rounded,
                color: Color(0xFFEA580C), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'بعض الأذونات غير مفعلة — اضغط هنا لإعدادها',
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFEA580C),
                    height: 1.4),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Color(0xFFEA580C), size: 14),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_block_channel.dart';
import 'timed_block_service.dart';

// ── Widget ────────────────────────────────────────────────────────────────────
//
// The user picks apps that are ALLOWED during a block session.
// Every other installed app will be blocked.
// The callback exposes the BLOCKED packages (all apps minus allowed ones).

class RestrictAppUsageWidget extends StatefulWidget {
  final bool allBlocked;

  /// Called whenever the selection changes.
  /// Passes the SET OF PACKAGES TO BLOCK (= all apps − allowed apps).
  final void Function(Set<String> packagesToBlock)? onPackagesChanged;

  const RestrictAppUsageWidget({
    super.key,
    required this.allBlocked,
    this.onPackagesChanged,
  });

  @override
  State<RestrictAppUsageWidget> createState() => _RestrictAppUsageWidgetState();
}

class _RestrictAppUsageWidgetState extends State<RestrictAppUsageWidget> {
  final TimedBlockService _blockService = TimedBlockService();
  final AppBlockChannel _channel = AppBlockChannel();

  static const _kPrefsKey = 'allowed_packages_during_block';

  List<InstalledApp> _allApps = [];
  bool _loadingApps = false;

  /// Packages the user explicitly marked as ALLOWED (not blocked).
  final Set<String> _allowedPackages = {};

  @override
  void initState() {
    super.initState();
    _blockService.addListener(_onBlockStateChanged);
    _loadPersistedPackages().then((_) => _loadApps());
  }

  @override
  void dispose() {
    _blockService.removeListener(_onBlockStateChanged);
    super.dispose();
  }

  // ── Persistence ───────────────────────────────────────────────────────────

  Future<void> _loadPersistedPackages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_kPrefsKey);
    if (stored != null && mounted) {
      setState(() => _allowedPackages.addAll(stored));
      _notifyBlockedPackages();
    }
  }

  Future<void> _persistPackages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kPrefsKey, _allowedPackages.toList());
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Everything NOT in _allowedPackages gets blocked.
  Set<String> get _packagesToBlock => _allApps
      .map((a) => a.packageName)
      .where((pkg) => !_allowedPackages.contains(pkg))
      .toSet();

  void _notifyBlockedPackages() {
    widget.onPackagesChanged?.call(_packagesToBlock);
  }

  // ── Data ─────────────────────────────────────────────────────────────────

  Future<void> _loadApps() async {
    setState(() => _loadingApps = true);
    final apps = await _channel.getInstalledApps();
    if (mounted) {
      setState(() {
        _allApps = apps;
        _loadingApps = false;
      });
      _notifyBlockedPackages();
    }
  }

  void _onBlockStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RestrictAppUsageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allBlocked && !oldWidget.allBlocked) {
      // "Block all" — clear allowed list so everything is blocked
      setState(() => _allowedPackages.clear());
      _persistPackages();
      _notifyBlockedPackages();
    } else if (!widget.allBlocked && oldWidget.allBlocked) {
      // Restore — reload persisted allowed list
      _loadPersistedPackages();
    }
  }

  void _openAppPicker() {
    if (_allApps.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppPickerSheet(
        allApps: _allApps,
        allowedPackages: Set.from(_allowedPackages),
        onDone: (allowed) {
          setState(() {
            _allowedPackages..clear()..addAll(allowed);
          });
          _persistPackages();
          _notifyBlockedPackages();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBlocking = _blockService.isActive;
    final int allowedCount = _allowedPackages.length;
    final int blockedCount = _allApps.length - allowedCount;

    final allowedApps = _allApps
        .where((a) => _allowedPackages.contains(a.packageName))
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.smartphone_outlined,
                  color: Color(0xFF2563EB), size: 22),
              const SizedBox(width: 10),
              const Text(
                'التطبيقات المسموحة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (_allApps.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$blockedCount محجوب',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE11D48),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (_loadingApps)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(
                    color: Color(0xFF2563EB), strokeWidth: 2),
              ),
            )
          else ...[
            // ── Allowed chips preview ────────────────────────────────
            if (allowedApps.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: allowedApps
                    .map((a) => _AppChip(app: a, allowed: true))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ── Info box ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: allowedApps.isEmpty
                    ? const Color(0xFFFFF7ED)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: allowedApps.isEmpty
                      ? const Color(0xFFFED7AA)
                      : const Color(0xFFBFDBFE),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    allowedApps.isEmpty
                        ? Icons.info_outline
                        : Icons.check_circle_outline,
                    color: allowedApps.isEmpty
                        ? const Color(0xFFEA580C)
                        : const Color(0xFF2563EB),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      allowedApps.isEmpty
                          ? 'سيتم حجب جميع التطبيقات أثناء الجلسة'
                          : 'سيتم السماح بـ $allowedCount تطبيق وحجب $blockedCount تطبيق',
                      style: TextStyle(
                        fontSize: 13,
                        color: allowedApps.isEmpty
                            ? const Color(0xFFEA580C)
                            : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Choose / edit button ─────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isBlocking ? null : _openAppPicker,
                icon: const Icon(Icons.apps_rounded, size: 20),
                label: Text(
                  allowedApps.isEmpty
                      ? 'اختر التطبيقات المسموحة أثناء الحجب'
                      : 'تعديل التطبيقات المسموحة',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  disabledBackgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.grey,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Chip preview ──────────────────────────────────────────────────────────────

class _AppChip extends StatelessWidget {
  final InstalledApp app;
  final bool allowed;

  const _AppChip({required this.app, required this.allowed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AppIcon(iconBase64: app.iconBase64, size: 18),
          const SizedBox(width: 6),
          Text(
            app.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable icon widget ──────────────────────────────────────────────────────

class _AppIcon extends StatelessWidget {
  final String iconBase64;
  final double size;

  const _AppIcon({required this.iconBase64, this.size = 40});

  @override
  Widget build(BuildContext context) {
    if (iconBase64.isEmpty) {
      return Icon(Icons.apps, size: size, color: const Color(0xFF9CA3AF));
    }
    try {
      return Image.memory(
        base64Decode(iconBase64),
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            Icon(Icons.apps, size: size, color: const Color(0xFF9CA3AF)),
      );
    } catch (_) {
      return Icon(Icons.apps, size: size, color: const Color(0xFF9CA3AF));
    }
  }
}

// ── Full-screen bottom sheet picker ──────────────────────────────────────────

class _AppPickerSheet extends StatefulWidget {
  final List<InstalledApp> allApps;
  final Set<String> allowedPackages;
  final void Function(Set<String> allowedPackages) onDone;

  const _AppPickerSheet({
    required this.allApps,
    required this.allowedPackages,
    required this.onDone,
  });

  @override
  State<_AppPickerSheet> createState() => _AppPickerSheetState();
}

class _AppPickerSheetState extends State<_AppPickerSheet> {
  late Set<String> _allowed;
  String _query = '';

  // 20 (list h-padding) + 24 (checkbox) + 12 + 44 (icon) + 12 = 112
  static const double _nameIndent = 112.0;

  @override
  void initState() {
    super.initState();
    _allowed = Set.from(widget.allowedPackages);
  }

  List<InstalledApp> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.allApps;
    return widget.allApps
        .where((a) => a.name.toLowerCase().contains(q))
        .toList();
  }

  bool get _allAllowed =>
      widget.allApps.every((a) => _allowed.contains(a.packageName));

  void _toggleAll() {
    setState(() {
      if (_allAllowed) {
        _allowed.clear();
      } else {
        _allowed.addAll(widget.allApps.map((a) => a.packageName));
      }
    });
  }

  void _toggle(InstalledApp app) {
    setState(() {
      _allowed.contains(app.packageName)
          ? _allowed.remove(app.packageName)
          : _allowed.add(app.packageName);
    });
  }

  int get _blockedCount => widget.allApps.length - _allowed.length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // ── Handle ───────────────────────────────────────────
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // ── Header ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'اختر التطبيقات المسموحة أثناء الحجب',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    if (_blockedCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_blockedCount محجوب',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE11D48),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // ── Subtitle hint ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'التطبيقات المحددة ستعمل — الباقي سيُحجب',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 14),

              // ── Search ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن تطبيق...',
                    hintStyle: const TextStyle(
                        fontSize: 14, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.grey, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Allow all / Block all toggle ──────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: _toggleAll,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _allAllowed
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _allAllowed
                            ? const Color(0xFFBFDBFE)
                            : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        children: [
                          Icon(
                            _allAllowed
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: _allAllowed
                                ? const Color(0xFF2563EB)
                                : const Color(0xFF9CA3AF),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _allAllowed
                                ? 'إلغاء تحديد الكل'
                                : 'السماح بجميع التطبيقات',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _allAllowed
                                  ? const Color(0xFF2563EB)
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),

              // ── Apps list ─────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => Directionality(
                    textDirection: TextDirection.ltr,
                    child: Divider(
                      height: 1,
                      indent: _nameIndent,
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                  itemBuilder: (_, i) {
                    final app = filtered[i];
                    final isAllowed = _allowed.contains(app.packageName);
                    return InkWell(
                      onTap: () => _toggle(app),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 10),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              // Checkbox
                              Icon(
                                isAllowed
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isAllowed
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFD1D5DB),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              // App icon — greyed out if blocked
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isAllowed
                                      ? const Color(0xFFEFF6FF)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Opacity(
                                    opacity: isAllowed ? 1.0 : 0.4,
                                    child: _AppIcon(
                                        iconBase64: app.iconBase64,
                                        size: 36),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // App name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: isAllowed
                                            ? Colors.black87
                                            : Colors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isAllowed ? 'مسموح' : 'سيُحجب',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isAllowed
                                            ? const Color(0xFF2563EB)
                                            : const Color(0xFFE11D48),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Bottom buttons ────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(context).padding.bottom + 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                              color: Color(0xFFE5E7EB), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onDone(Set.from(_allowed));
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          _blockedCount == 0
                              ? 'تأكيد (لا حجب)'
                              : 'تأكيد — حجب $_blockedCount تطبيق',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

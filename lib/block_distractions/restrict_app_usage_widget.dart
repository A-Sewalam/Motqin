import 'package:flutter/material.dart';
import 'app_block_channel.dart';
import 'timed_block_service.dart';

// ── Widget ────────────────────────────────────────────────────────────────────

class RestrictAppUsageWidget extends StatefulWidget {
  final bool allBlocked;

  const RestrictAppUsageWidget({super.key, required this.allBlocked});

  @override
  State<RestrictAppUsageWidget> createState() => _RestrictAppUsageWidgetState();
}

class _RestrictAppUsageWidgetState extends State<RestrictAppUsageWidget> {
  final TimedBlockService _blockService = TimedBlockService();
  final AppBlockChannel _channel = AppBlockChannel();

  /// All apps installed on the device
  List<InstalledApp> _allApps = [];
  bool _loadingApps = false;

  /// Package names the user chose to block
  final Set<String> _selectedPackages = {};

  @override
  void initState() {
    super.initState();
    _blockService.addListener(_onBlockStateChanged);
    _loadApps();
  }

  @override
  void dispose() {
    _blockService.removeListener(_onBlockStateChanged);
    super.dispose();
  }

  Future<void> _loadApps() async {
    setState(() => _loadingApps = true);
    final apps = await _channel.getInstalledApps();
    if (mounted) setState(() { _allApps = apps; _loadingApps = false; });
  }

  void _onBlockStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(RestrictAppUsageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.allBlocked && !oldWidget.allBlocked) {
      setState(() => _selectedPackages
          .addAll(_allApps.map((a) => a.packageName)));
    } else if (!widget.allBlocked && oldWidget.allBlocked) {
      setState(() => _selectedPackages.clear());
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
        selectedPackages: Set.from(_selectedPackages),
        onDone: (selected) => setState(() {
          _selectedPackages..clear()..addAll(selected);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBlocking = _blockService.isActive;
    final int count = _selectedPackages.length;

    // Selected app objects for the chip preview
    final selected = _allApps
        .where((a) => _selectedPackages.contains(a.packageName))
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
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.smartphone_outlined,
                  color: Color(0xFF2563EB), size: 22),
              const SizedBox(width: 10),
              const Text(
                'التطبيقات المحجوبة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count محجوب',
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

          // ── Loading indicator ────────────────────────────────────────
          if (_loadingApps)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(
                    color: Color(0xFF2563EB), strokeWidth: 2),
              ),
            )
          else ...[
            // ── Selected chips preview ─────────────────────────────────
            if (selected.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selected
                    .map((a) => _AppChip(app: a, isBlocking: isBlocking))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ── Empty state ────────────────────────────────────────────
            if (selected.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFFE5E7EB), width: 1.5),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: Color(0xFFD1D5DB), size: 36),
                    SizedBox(height: 8),
                    Text(
                      'لم تختر أي تطبيق للحجب بعد',
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // ── Choose apps button ─────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isBlocking ? null : _openAppPicker,
                icon: const Icon(Icons.apps_rounded, size: 20),
                label: Text(
                  count == 0
                      ? 'اختر التطبيقات للحجب'
                      : 'تعديل التطبيقات المحجوبة',
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
  final bool isBlocking;

  const _AppChip({required this.app, required this.isBlocking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFECACA), width: 1),
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
              color: Color(0xFFE11D48),
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
        InstalledApp(
                name: '', packageName: '', iconBase64: iconBase64)
            .iconBytes,
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
  final Set<String> selectedPackages;
  final void Function(Set<String>) onDone;

  const _AppPickerSheet({
    required this.allApps,
    required this.selectedPackages,
    required this.onDone,
  });

  @override
  State<_AppPickerSheet> createState() => _AppPickerSheetState();
}

class _AppPickerSheetState extends State<_AppPickerSheet> {
  late Set<String> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedPackages);
  }

  List<InstalledApp> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.allApps;
    return widget.allApps
        .where((a) => a.name.toLowerCase().contains(q))
        .toList();
  }

  bool get _allSelected =>
      widget.allApps.every((a) => _selected.contains(a.packageName));

  void _toggleAll() {
    setState(() {
      if (_allSelected) {
        _selected.clear();
      } else {
        _selected.addAll(widget.allApps.map((a) => a.packageName));
      }
    });
  }

  void _toggle(InstalledApp app) {
    setState(() {
      _selected.contains(app.packageName)
          ? _selected.remove(app.packageName)
          : _selected.add(app.packageName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final selectedCount = _selected.length;

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
              // ── Handle ─────────────────────────────────────────────
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

              // ── Header ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'اختر التطبيقات للحجب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    if (selectedCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$selectedCount مختار',
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
              const SizedBox(height: 14),

              // ── Search ─────────────────────────────────────────────
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

              // ── Select all ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: _toggleAll,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _allSelected
                          ? const Color(0xFFFFE4E6)
                          : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _allSelected
                            ? const Color(0xFFFECACA)
                            : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _allSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: _allSelected
                              ? const Color(0xFFE11D48)
                              : const Color(0xFF9CA3AF),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _allSelected ? 'إلغاء تحديد الكل' : 'تحديد الكل',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _allSelected
                                ? const Color(0xFFE11D48)
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),

              // ── Apps list ──────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 64),
                  itemBuilder: (_, i) {
                    final app = filtered[i];
                    final isSelected =
                        _selected.contains(app.packageName);
                    return InkWell(
                      onTap: () => _toggle(app),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 10),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              // Checkbox on the far left
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? const Color(0xFFE11D48)
                                    : const Color(0xFFD1D5DB),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              // App icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFE4E6)
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: _AppIcon(
                                      iconBase64: app.iconBase64,
                                      size: 36),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // App name
                              Expanded(
                                child: Text(
                                  app.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFFE11D48)
                                        : Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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

              // ── Bottom buttons ─────────────────────────────────────
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
                          widget.onDone(Set.from(_selected));
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE11D48),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          selectedCount == 0
                              ? 'تأكيد'
                              : 'حجب $selectedCount تطبيق',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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

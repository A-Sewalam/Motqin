import 'package:flutter/material.dart';
import 'timed_block_service.dart';

class BlockOptionsWidget extends StatefulWidget {
  final void Function(bool blocked) onToggleBlock;

  const BlockOptionsWidget({super.key, required this.onToggleBlock});

  @override
  State<BlockOptionsWidget> createState() => _BlockOptionsWidgetState();
}

class _BlockOptionsWidgetState extends State<BlockOptionsWidget> {
  int _selectedOption = 0;
  DateTime? _selectedDateTime;

  final TimedBlockService _blockService = TimedBlockService();

  bool get _canActivate {
    if (_blockService.isActive) return false;
    if (_selectedOption == 1) return true;
    if (_selectedOption == 2 && _selectedDateTime != null) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
    _blockService.addListener(_onServiceUpdate);
    // Restore session from SharedPreferences if one was active
    _blockService.init().then((_) {
      if (mounted) setState(() {});
      widget.onToggleBlock(_blockService.isActive);
    });
  }

  @override
  void dispose() {
    _blockService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (!mounted) return;
    setState(() {});
    widget.onToggleBlock(_blockService.isActive);
    if (_blockService.status == BlockStatus.expired) {
      _showDialog(
        icon: Icons.lock_open_outlined,
        iconColor: const Color(0xFF22C55E),
        message: 'انتهى وقت الحجب — تم فتح التطبيقات تلقائياً',
      );
    }
  }

  // ── Permission dialog — shown when pressing activate and accessibility not enabled
  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إذن مطلوب',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'لحجب التطبيقات يجب تفعيل خدمة إمكانية الوصول لتطبيق موتقن.\n\nاضغط "فتح الإعدادات" ثم فعّل موتقن.',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB)),
            onPressed: () async {
              Navigator.of(context).pop();
              await _blockService.requestPermission();
            },
            child: const Text('فتح الإعدادات',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked == null || !mounted) return;

    final TimeOfDay? time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final chosen = DateTime(
        picked.year, picked.month, picked.day, time.hour, time.minute);
    if (chosen.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يجب اختيار وقت في المستقبل',
                textDirection: TextDirection.rtl)),
      );
      return;
    }
    setState(() => _selectedDateTime = chosen);
  }

  Future<void> _onActivatePressed() async {
    // 1. Check accessibility permission first
    final granted = await _blockService.isPermissionGranted();
    if (!granted) {
      _showPermissionDialog();
      return;
    }

    // 2. Start block
    try {
      final endTime = _selectedOption == 2 && _selectedDateTime != null
          ? _selectedDateTime!
          : DateTime.now().add(const Duration(days: 365));

      await _blockService.startBlock(
        mode: _selectedOption == 1
            ? BlockMode.untilStudyPlanEnd
            : BlockMode.untilDateTime,
        endTime: endTime,
      );

      // 3. Request Device Admin after block starts (only if not already active)
      final adminActive = await _blockService.isDeviceAdminActive();
      if (!adminActive) {
        await _blockService.requestDeviceAdmin();
      }

      final session = _blockService.session!;
      _showDialog(
        icon: Icons.block,
        iconColor: const Color(0xFFE91E63),
        message: session.mode == BlockMode.untilStudyPlanEnd
            ? 'تم حجب التطبيقات حتى انتهاء خطتك الدراسية'
            : 'تم حجب التطبيقات حتى '
                '${session.endTime.day}/${session.endTime.month}/${session.endTime.year} '
                'الساعة ${session.endTime.hour}:${session.endTime.minute.toString().padLeft(2, '0')}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('خطأ: $e', textDirection: TextDirection.rtl)),
      );
    }
  }

  void _showDialog(
      {required IconData icon,
      required Color iconColor,
      required String message}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontSize: 15, color: Colors.black87),
                  textDirection: TextDirection.rtl),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = _blockService.isActive;

    return _SectionCard(
      icon: Icons.shield_outlined,
      iconColor: const Color(0xFF7C3AED),
      title: 'خيارات الحجب',
      child: Column(
        children: [
          if (isActive && _blockService.session != null) ...[
            _buildCountdownBanner(),
            const SizedBox(height: 12),
            _buildLockNotice(),
            const SizedBox(height: 16),
          ],

          if (!isActive) ...[
            _optionCard(
              option: 1,
              icon: Icons.access_time,
              iconBg: const Color(0xFFDBEAFF),
              iconColor: const Color(0xFF2962E0),
              title: 'حجب حتى انتهاء خطتي الدراسية',
              titleColor: const Color(0xFF2962E0),
              subtitle:
                  'سيتم حجب التطبيقات حتى تكمل جميع مهام الدراسة المخططة',
            ),
            const SizedBox(height: 12),
            _optionCard(
              option: 2,
              icon: Icons.calendar_month_outlined,
              iconBg: const Color(0xFFEDE9FE),
              iconColor: const Color(0xFF7C3AED),
              title: 'حجب حتى وقت محدد',
              titleColor: const Color(0xFF7C3AED),
              subtitle: _selectedDateTime != null
                  ? 'حتى: ${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}  '
                      '${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                  : 'حدد وقت انتهاء الحجب بدقة',
            ),
            if (_selectedOption == 2) ...[
              const SizedBox(height: 14),
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'حدد وقت انتهاء الحجب',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  suffixIcon: GestureDetector(
                    onTap: _pickDateTime,
                    child: const Icon(Icons.calendar_month_outlined,
                        color: Color(0xFF7C3AED), size: 20),
                  ),
                ),
                readOnly: true,
                onTap: _pickDateTime,
                controller: TextEditingController(
                  text: _selectedDateTime != null
                      ? '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}'
                          '  ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                      : '',
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed: _canActivate ? _onActivatePressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.grey,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'تفعيل حجب التطبيقات',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCountdownBanner() {
    final session = _blockService.session!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.timer_outlined,
                  color: Color(0xFFE91E63), size: 18),
              SizedBox(width: 6),
              Text('الحجب نشط — الوقت المتبقي',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE91E63))),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            session.formattedRemaining,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91E63),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: session.progressFraction,
              minHeight: 6,
              backgroundColor: const Color(0xFFFFCDD2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFE91E63)),
            ),
          ),
          if (session.mode == BlockMode.untilDateTime) ...[
            const SizedBox(height: 8),
            Text(
              'ينتهي في ${session.endTime.day}/${session.endTime.month}/${session.endTime.year}'
              '  ${session.endTime.hour}:${session.endTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLockNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock_outline, color: Color(0xFF6B7280), size: 18),
          SizedBox(width: 8),
          Text(
            'لا يمكن إلغاء الحجب حتى انتهاء الوقت',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _optionCard({
    required int option,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required Color titleColor,
    required String subtitle,
  }) {
    final bool selected = _selectedOption == option;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = selected ? 0 : option;
          if (option != 2) _selectedDateTime = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? iconBg.withOpacity(0.5)
              : const Color(0xFFF9FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? iconColor.withOpacity(0.6)
                : const Color(0xFFE6E7EB),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration:
                  BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: titleColor)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
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
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

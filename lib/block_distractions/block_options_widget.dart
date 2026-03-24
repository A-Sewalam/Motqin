import 'package:flutter/material.dart';

class BlockOptionsWidget extends StatefulWidget {
  final void Function(bool blocked) onToggleBlock;

  const BlockOptionsWidget({super.key, required this.onToggleBlock});

  @override
  State<BlockOptionsWidget> createState() => _BlockOptionsWidgetState();
}

class _BlockOptionsWidgetState extends State<BlockOptionsWidget> {
  int _selectedOption = 0; // 0 = none, 1 = schedule, 2 = time limit
  DateTime? _selectedDateTime;
  bool _isBlocked = false;

  bool get _canActivate =>
      _selectedOption == 1 ||
      (_selectedOption == 2 && _selectedDateTime != null);

  Future<void> _pickDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;

    final TimeOfDay? time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute);
    });
  }

  void _onActivatePressed() {
    setState(() => _isBlocked = !_isBlocked);
    widget.onToggleBlock(_isBlocked);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        content: Row(
          children: [
            Icon(
              _isBlocked ? Icons.block : Icons.check_circle_outline,
              color: _isBlocked ? const Color(0xFFE91E63) : const Color(0xFF22C55E),
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _isBlocked
                    ? _selectedOption == 2 && _selectedDateTime != null
                        ? 'تم حجب التطبيقات حتى '
                            '${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} '
                            'الساعة ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                        : 'تم حجب التطبيقات حتى انتهاء الخطة الدراسية'
                    : 'تم الغاء حجب التطبيقات',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.shield_outlined,
      iconColor: const Color(0xFF7C3AED),
      title: 'خيارات الحجب',
      child: Column(
        children: [
          // ── Option 1 ───────────────────────────────────────────
          _optionCard(
            option: 1,
            icon: Icons.access_time,
            iconBg: const Color(0xFFDBEAFF),
            iconColor: const Color(0xFF2962E0),
            title: 'حجب حتى انتهاء خطتي الدراسية',
            titleColor: const Color(0xFF2962E0),
            subtitle: 'سيتم حجب التطبيقات حتى تكمل جميع مهام الدراسة المخططة',
          ),
          const SizedBox(height: 12),

          // ── Option 2 ───────────────────────────────────────────
          _optionCard(
            option: 2,
            icon: Icons.calendar_month_outlined,
            iconBg: const Color(0xFFEDE9FE),
            iconColor: const Color(0xFF7C3AED),
            title: 'حجب في اوقات محددة في اليوم',
            titleColor: const Color(0xFF7C3AED),
            subtitle: _selectedDateTime != null
                ? 'حتى: ${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}  '
                    '${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                : 'حدد وقت انتهاء الحجب بدقة',
          ),

          // ── Time field — only when option 2 selected ───────────
          if (_selectedOption == 2) ...[
            const SizedBox(height: 14),
            TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'حدد وقت انتهاء الحجب',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
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
                    ? '${_selectedDateTime!.hour}:'
                        '${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                    : '',
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Activate / Cancel button ───────────────────────────
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: _canActivate || _isBlocked ? _onActivatePressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBlocked
                    ? const Color(0xFF22c55e)
                    : const Color(0xFFE91E63),
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.grey,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _isBlocked ? 'الغاء حجب التطبيقات' : 'تفعيل حجب التطبيقات',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
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
          if (_isBlocked) {
            _isBlocked = false;
            widget.onToggleBlock(false);
          }
          if (option != 2) _selectedDateTime = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? iconBg.withOpacity(0.5) : const Color(0xFFF9FAFC),
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
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: titleColor),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
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

import 'dart:async';
import 'package:flutter/material.dart';

class StudyTimerWidget extends StatefulWidget {
  const StudyTimerWidget({super.key});

  @override
  State<StudyTimerWidget> createState() => _StudyTimerWidgetState();
}

class _StudyTimerWidgetState extends State<StudyTimerWidget> {
  static const int _defaultSeconds = 25 * 60;
  static const int _breakSeconds = 5 * 60;

  int _secondsLeft = _defaultSeconds;
  bool _isRunning = false;
  bool _isBreak = false;
  Timer? _timer;

  final TextEditingController _customMinutesController =
      TextEditingController();

  final List<Map<String, dynamic>> _presets = [
    {'label': 'دقيقة (بومودورو) 25',    'minutes': 25},
    {'label': 'دقيقة (جلسة متوسطة) 45', 'minutes': 45},
    {'label': 'دقيقة (جلسة طويلة) 60',  'minutes': 60},
    {'label': 'دقيقة (جلسة مكثفة) 90',  'minutes': 90},
  ];

  String get _timeDisplay {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _start() {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        setState(() {
          _isBreak = !_isBreak;
          _secondsLeft = _isBreak ? _breakSeconds : _defaultSeconds;
          _isRunning = false;
        });
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _secondsLeft = _defaultSeconds;
    });
  }

  void _setPreset(int minutes) {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _secondsLeft = minutes * 60;
    });
  }

  void _setCustomTime() {
    final int? minutes = int.tryParse(_customMinutesController.text.trim());
    if (minutes != null && minutes > 0) {
      _setPreset(minutes);
      _customMinutesController.clear();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _customMinutesController.dispose();
    super.dispose();
  }

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
          // Header
          Row(
            children: const [
              Icon(Icons.timer_outlined, color: Color(0xFF1FA24F), size: 22),
              SizedBox(width: 10),
              Text(
                'مؤقت الدراسة',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Timer display ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDCFBE9), Color(0xFFDAEBFB)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  _timeDisplay,
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isBreak ? 'وقت الراحة' : 'دقائق متبقية',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Control buttons: Play | Pause | Reset ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controlBtn(
                icon: Icons.refresh,
                color: const Color(0xFF6B7280),
                onTap: _reset,
              ),
              const SizedBox(width: 12),
              _controlBtn(
                icon: Icons.pause,
                color: const Color(0xFFEAB308),
                onTap: _pause,
              ),
              const SizedBox(width: 12),
              _controlBtn(
                icon: Icons.play_arrow,
                color: const Color(0xFF22C55E),
                onTap: _start,
              ),
              
            ],
          ),
          const SizedBox(height: 24),

          // ── Suggested times title ─────────────────────────────
          const Text(
            'أوقات مقترحة للدراسة',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),

          // ── Preset cards ──────────────────────────────────────
          ..._presets.map((p) => _presetCard(p['label'], p['minutes'])),
          const SizedBox(height: 16),

          // ── Custom time input ─────────────────────────────────
          const Text(
            'وقت مخصص (بالدقائق):',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _customMinutesController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            onSubmitted: (_) => _setCustomTime(),
            decoration: InputDecoration(
              hintText: '30',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'لتعيين الوقت اضغط Enter',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _controlBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _presetCard(String label, int minutes) {
    return GestureDetector(
      onTap: () => _setPreset(minutes),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
    );
  }
}

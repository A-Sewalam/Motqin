import 'package:flutter/material.dart';

class _AppItem {
  final String emoji;
  final String nameAr;
  final String usage;

  const _AppItem({
    required this.emoji,
    required this.nameAr,
    required this.usage,
  });
}

class RestrictAppUsageWidget extends StatefulWidget {
  final bool allBlocked;

  const RestrictAppUsageWidget({super.key, required this.allBlocked});

  @override
  State<RestrictAppUsageWidget> createState() => _RestrictAppUsageWidgetState();
}

class _RestrictAppUsageWidgetState extends State<RestrictAppUsageWidget> {
  static const List<_AppItem> _apps = [
    _AppItem(emoji: '📘', nameAr: 'فيسبوك',   usage: 'استخدام: 2h 15m'),
    _AppItem(emoji: '📷', nameAr: 'إنستغرام', usage: 'استخدام: 1h 45m'),
    _AppItem(emoji: '🎵', nameAr: 'تيك توك',  usage: 'استخدام: 23h 9m'),
    _AppItem(emoji: '👻', nameAr: 'سناب شات', usage: 'استخدام: 45m'),
    _AppItem(emoji: '🐦', nameAr: 'تويتر',    usage: 'استخدام: 1h 1m'),
    _AppItem(emoji: '📺', nameAr: 'يوتيوب',   usage: 'استخدام: 3h 40m'),
    _AppItem(emoji: '💬', nameAr: 'واتساب',   usage: 'استخدام: 51m'),
    _AppItem(emoji: '✈️', nameAr: 'تيلغرام',  usage: 'استخدام: 22m'),
  ];

  // Per-app overrides — user can still toggle individually
  late List<bool> _isAllowed;

  @override
  void initState() {
    super.initState();
    _isAllowed = List.filled(_apps.length, true);
  }

  @override
  void didUpdateWidget(RestrictAppUsageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When parent blocks/unblocks all, override all per-app values
    if (widget.allBlocked != oldWidget.allBlocked) {
      setState(() {
        _isAllowed = List.filled(_apps.length, !widget.allBlocked);
      });
    }
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
          Row(
            children: const [
              Icon(Icons.smartphone_outlined, color: Color(0xFF2563EB), size: 22),
              SizedBox(width: 10),
              Text(
                'حجب التطبيقات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 490,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _apps.length,
              itemBuilder: (_, i) => _appCard(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appCard(int i) {
    final app = _apps[i];
    final bool allowed = _isAllowed[i];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
      decoration: BoxDecoration(
        color: allowed ? const Color(0xFFF0FFF4) : const Color(0xFFfef2f2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: allowed ? const Color(0xffbdf5d2) : const Color(0xFFfecaca),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(app.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 8),
          Text(
            app.nameAr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(app.usage,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _isAllowed[i] = !_isAllowed[i]),
              style: ElevatedButton.styleFrom(
                backgroundColor: allowed
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                allowed ? 'مسموح' : 'محجوب',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

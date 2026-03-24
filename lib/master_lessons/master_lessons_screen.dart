import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen 1 — Subjects List
// ─────────────────────────────────────────────────────────────────────────────

class MasterLessonsScreen extends StatelessWidget {
  const MasterLessonsScreen({super.key});

  static const List<Map<String, dynamic>> _subjects = [
    {
      'nameAr': 'الإنجليزية',
      'nameEn': 'English',
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFF2563EB),
      'bgColor': Color(0xFFDAEAFF),
    },
    {
      'nameAr': 'الرياضيات',
      'nameEn': 'Mathematics',
      'icon': Icons.calculate_outlined,
      'color': Color(0xFF16A34A),
      'bgColor': Color(0xFFDCFCE7),
    },
    {
      'nameAr': 'العلوم',
      'nameEn': 'Science',
      'icon': Icons.biotech_outlined,
      'color': Color(0xFF7C3AED),
      'bgColor': Color(0xFFEDE9FE),
    },
    {
      'nameAr': 'الجغرافيا',
      'nameEn': 'Geography',
      'icon': Icons.language_outlined,
      'color': Color(0xFFEA580C),
      'bgColor': Color(0xFFFFEDD5),
    },
    {
      'nameAr': 'الفنون',
      'nameEn': 'Art',
      'icon': Icons.palette_outlined,
      'color': Color(0xFFDB2777),
      'bgColor': Color(0xFFFFE4F0),
    },
    {
      'nameAr': 'الموسيقى',
      'nameEn': 'Music',
      'icon': Icons.music_note_outlined,
      'color': Color(0xFFD97706),
      'bgColor': Color(0xFFFEF9C3),
    },
  ];

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
            'أتقن دروسك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.appbartitlesColor,
            ),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'اختر المادة التي تريد دراستها',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final s = _subjects[index];
                  return _SubjectCard(subject: s);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Map<String, dynamic> subject;
  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    final Color color = subject['color'] as Color;
    final Color bgColor = subject['bgColor'] as Color;
    final IconData icon = subject['icon'] as IconData;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SubjectUnitsScreen(
            subjectNameAr: subject['nameAr'] as String,
            subjectNameEn: subject['nameEn'] as String,
            color: color,
            bgColor: bgColor,
            icon: icon,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 28),
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 52, color: color),
            const SizedBox(height: 12),
            Text(
              subject['nameAr'] as String,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subject['nameEn'] as String,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 2 — Units List
// ─────────────────────────────────────────────────────────────────────────────

class SubjectUnitsScreen extends StatelessWidget {
  final String subjectNameAr;
  final String subjectNameEn;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const SubjectUnitsScreen({
    super.key,
    required this.subjectNameAr,
    required this.subjectNameEn,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  List<Map<String, dynamic>> get _units => [
        {'titleEn': 'Unit 1', 'titleAr': 'الوحدة الأولى',  'progress': 1.0,  'status': 'مكتملة'},
        {'titleEn': 'Unit 2', 'titleAr': 'الوحدة الثانية', 'progress': 0.8,  'status': 'متابعة'},
        {'titleEn': 'Unit 3', 'titleAr': 'الوحدة الثالثة', 'progress': 0.6,  'status': 'متابعة'},
        {'titleEn': 'Unit 4', 'titleAr': 'الوحدة الرابعة', 'progress': 0.3,  'status': 'متابعة'},
        {'titleEn': 'Unit 5', 'titleAr': 'الوحدة الخامسة', 'progress': 0.0,  'status': 'بدء'},
        {'titleEn': 'Unit 6', 'titleAr': 'الوحدة السادسة', 'progress': 0.0,  'status': 'بدء'},
        {'titleEn': 'Unit 7', 'titleAr': 'الوحدة السابعة', 'progress': 0.0,  'status': 'بدء'},
        {'titleEn': 'Unit 8', 'titleAr': 'الوحدة الثامنة', 'progress': 0.0,  'status': 'بدء'},
      ];

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
          title: Text(
            subjectNameEn,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Subject header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Icon(icon, size: 52, color: color),
                  const SizedBox(height: 10),
                  Text(
                    subjectNameAr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'اختر الوحدة التي تريد دراستها',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Units
            ..._units.map((unit) => _UnitCard(
                  unit: unit,
                  color: color,
                  bgColor: bgColor,
                  icon: icon,
                  subjectNameAr: subjectNameAr,
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final Map<String, dynamic> unit;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String subjectNameAr;

  const _UnitCard({
    required this.unit,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.subjectNameAr,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = unit['progress'] as double;
    final String status = unit['status'] as String;
    final bool isDone = progress == 1.0;
    final bool notStarted = progress == 0.0;

    final Color btnColor = isDone
        ? const Color(0xFF16A34A)
        : notStarted
            ? Colors.grey.shade300
            : color;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UnitVocabularyScreen(
            unitTitleEn: unit['titleEn'] as String,
            unitTitleAr: unit['titleAr'] as String,
            subjectNameAr: subjectNameAr,
            color: color,
            bgColor: bgColor,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon + check
            Row(
              children: [
                const Spacer(),
                Icon(icon, size: 40, color: color.withOpacity(0.85)),
                Expanded(
                  child: isDone
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: const Icon(Icons.check_circle,
                              color: Color(0xFF16A34A), size: 22),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              unit['titleEn'] as String,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              unit['titleAr'] as String,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Progress bar
            Row(
              children: [
                const Text('التقدم',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDone ? const Color(0xFF16A34A) : color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${(progress * 100).toInt()}%',
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => UnitVocabularyScreen(
                      unitTitleEn: unit['titleEn'] as String,
                      unitTitleAr: unit['titleAr'] as String,
                      subjectNameAr: subjectNameAr,
                      color: color,
                      bgColor: bgColor,
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  foregroundColor:
                      notStarted ? Colors.grey : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(status,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 3 — Unit Vocabulary
// ─────────────────────────────────────────────────────────────────────────────

class UnitVocabularyScreen extends StatelessWidget {
  final String unitTitleEn;
  final String unitTitleAr;
  final String subjectNameAr;
  final Color color;
  final Color bgColor;

  const UnitVocabularyScreen({
    super.key,
    required this.unitTitleEn,
    required this.unitTitleAr,
    required this.subjectNameAr,
    required this.color,
    required this.bgColor,
  });

  static const List<Map<String, String>> _tips = [
    {'emoji': '🎯', 'text': 'ابدأ بالكلمات الأساسية أولاً'},
    {'emoji': '🔄', 'text': 'راجع الكلمات يومياً'},
    {'emoji': '📝', 'text': 'استخدم الكلمات في جمل'},
  ];

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
          title: Text(
            'حفظ المفردات - $unitTitleEn',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.appbartitlesColor,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // ── Subject header card ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    subjectNameAr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'اختر نوع المفردات التي تريد دراستها',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ── Card 1: المفردات الأساسية ─────────────────────────
            _vocabCard(
              context: context,
              titleAr: 'المفردات الأساسية',
              description: 'أهم 20 كلمة يجب حفظها في هذه الوحدة',
              badgeIcon: Icons.star_border_outlined,
              badgeText: 'كلمة أساسية 20',
              badgeColor: const Color(0xFFE53935),
              badgeBg: const Color(0xFFFFEBEE),
              btnColor: const Color(0xFFE53935),
              btnText: 'ابدأ الحفظ',
            ),

            const SizedBox(height: 16),

            // ── Card 2: المفردات الإضافية ─────────────────────────
            _vocabCard(
              context: context,
              titleAr: 'المفردات الإضافية',
              description: 'كلمة إضافية لتوسيع مفرداتك 30',
              badgeIcon: Icons.add_outlined,
              badgeText: 'كلمة إضافية 30',
              badgeColor: const Color(0xFF3B82F6),
              badgeBg: const Color(0xFFdbeafe),
              btnColor: const Color(0xFF3B82F6),
              btnText: 'ابدأ الحفظ',
            ),

            const SizedBox(height: 24),

            // ── Tips section ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'نصائح للحفظ الفعال',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._tips.asMap().entries.map((entry) {
                    final tip = entry.value;
                    

                    // Pick a color based on the index
                    final Color tileBg;
                    switch (entry.key) {
                      case 0:
                        tileBg = const Color(0xFFeff6ff); 
                        break;
                      case 1:
                        tileBg = const Color(0xFFf0fdf4);
                        break;
                      case 2:
                        tileBg = const Color(0xFFfaf5ff);
                        break;
                      default:
                        tileBg = Colors.white;
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: tileBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(tip['emoji']!,
                              style: const TextStyle(fontSize: 32)),
                          const SizedBox(height: 8),
                          Text(
                            tip['text']!,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vocabCard({
    required BuildContext context,
    required String titleAr,
    required String description,
    required IconData badgeIcon,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
    required Color btnColor,
    required String btnText,
  }) {
    return Container(
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
        children: [
          // Circle icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: badgeBg,
              shape: BoxShape.circle,
            ),
            child: Icon(badgeIcon, color: badgeColor, size: 34),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            titleAr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
          const SizedBox(height: 4),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 14),

          // Badge chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(badgeIcon, color: badgeColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                btnText,
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

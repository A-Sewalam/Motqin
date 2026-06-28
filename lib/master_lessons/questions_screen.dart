import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';

class QuestionsScreen extends StatefulWidget {
  final String subjectNameAr;
  final String lessonNameAr;
  final int totalQuestions;
  final int ignoredQuestions;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const QuestionsScreen({
    super.key,
    required this.subjectNameAr,
    required this.lessonNameAr,
    required this.totalQuestions,
    required this.ignoredQuestions,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  // State management vectors initialized dynamically from widget parameters
  late int _currentTotalCount;
  late int _currentIgnoredCount;

  // Local list template mapped directly to reflect a description context
  final List<Map<String, dynamic>> _questionsList = [
    {'question': 'السؤال الأول هنا', 'description':'شرح مبسط يغطي جوانب هذا المفهوم', 'isIgnored': false},
    {'question': 'السؤال الثاني هنا', 'description': 'شرح مبسط يغطي جوانب هذا المفهوم', 'isIgnored': false},
    {'question': 'السؤال الثالث هنا', 'description':'شرح مبسط يغطي جوانب هذا المفهوم', 'isIgnored': false},
    {'question': 'السؤال الرابع هنا', 'description':'شرح مبسط يغطي جوانب هذا المفهوم', 'isIgnored': false},
  ];

  @override
  void initState() {
    super.initState();
    _currentTotalCount = widget.totalQuestions;
    _currentIgnoredCount = widget.ignoredQuestions;
  }

  void _toggleIgnoreStatus(int index) {
    setState(() {
      final bool currentStatus = _questionsList[index]['isIgnored'] as bool;
      _questionsList[index]['isIgnored'] = !currentStatus;

      if (!currentStatus) {
        // Moving to ignored status
        _currentIgnoredCount++;
        if (_currentTotalCount > 0) _currentTotalCount--;
      } else {
        // Restoring back from ignored status
        if (_currentIgnoredCount > 0) _currentIgnoredCount--;
        _currentTotalCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgColor, // Matches master lessons screen
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            // ── TOP HEADER PANEL ───────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.subjectNameAr} - ${widget.lessonNameAr}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: 0.0,
                      minHeight: 4,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start button positioned compactly at the left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        // Start quiz core action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981), // Green tone matching the image template
                        foregroundColor: Colors.white,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'ابدأ',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── METRICS SUB-HEADER (Live Counter State Row) ────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_currentTotalCount سؤال',
                    style: TextStyle(
                      fontSize: 14, 
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    '$_currentIgnoredCount متجاوز',
                    style: TextStyle(
                      fontSize: 14, 
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),

            // ── QUESTION ITEMS LIST VIEW ───────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: _questionsList.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
                itemBuilder: (context, index) {
                  final item = _questionsList[index];
                  final bool isIgnored = item['isIgnored'] as bool;

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isIgnored ? 0.45 : 1.0, // Visually demotes an item when ignored
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          // Column 1: Question Text
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['question'] as String,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                decoration: isIgnored ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Column 2 (Middle): Description text
                          Expanded(
                            flex: 3,
                            child: Text(
                              item['description'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          // Column 3: Ignore Action Trigger Button (Eye Indicator)
                          IconButton(
                            onPressed: () => _toggleIgnoreStatus(index),
                            icon: Icon(
                              isIgnored ? Icons.visibility_off : Icons.visibility_outlined,
                              size: 20,
                              color: isIgnored ? Colors.amber.shade700 : Colors.grey.shade400,
                            ),
                            tooltip: isIgnored ? 'إلغاء التجاوز' : 'تجاوز هذا السؤال',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
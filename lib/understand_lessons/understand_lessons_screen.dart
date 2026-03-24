import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen 1 — Subjects List
// ─────────────────────────────────────────────────────────────────────────────

class UnderstandLessonsScreen extends StatelessWidget {
  const UnderstandLessonsScreen({super.key});

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
            'افهم دروسك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.appbartitlesColor,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // ── Brain icon header ──────────────────────────────────
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 44),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'اختر المادة التي تريد فهمها',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'سأساعدك في فهم الدروس بطريقة تفاعلية',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // ── Subject cards ──────────────────────────────────────
            ..._subjects.map((s) => _SubjectRow(subject: s)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  final Map<String, dynamic> subject;
  const _SubjectRow({required this.subject});

  @override
  Widget build(BuildContext context) {
    final Color color = subject['color'] as Color;
    final Color bgColor = subject['bgColor'] as Color;
    final IconData icon = subject['icon'] as IconData;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UnderstandUnitsScreen(
            subjectNameAr: subject['nameAr'] as String,
            subjectNameEn: subject['nameEn'] as String,
            color: color,
            bgColor: bgColor,
            icon: icon,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject['nameAr'] as String,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subject['nameEn'] as String,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 2 — Units List
// ─────────────────────────────────────────────────────────────────────────────

class UnderstandUnitsScreen extends StatelessWidget {
  final String subjectNameAr;
  final String subjectNameEn;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const UnderstandUnitsScreen({
    super.key,
    required this.subjectNameAr,
    required this.subjectNameEn,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  // Mock units with topic bullets
  List<Map<String, dynamic>> get _units => [
        {
          'titleEn': 'Unit 1',
          'titleAr': 'الوحدة الأولى',
          'topics': ['Present Simple', 'Basic Vocabulary', 'Greetings'],
        },
        {
          'titleEn': 'Unit 2',
          'titleAr': 'الوحدة الثانية',
          'topics': ['Present Continuous', 'Family Members', 'Daily Activities'],
        },
        {
          'titleEn': 'Unit 3',
          'titleAr': 'الوحدة الثالثة',
          'topics': ['Past Simple', 'Time Expressions', 'School Life'],
        },
        {
          'titleEn': 'Unit 4',
          'titleAr': 'الوحدة الرابعة',
          'topics': ['Future Tense', 'Plans and Dreams', 'Weather'],
        },
        {
          'titleEn': 'Unit 5',
          'titleAr': 'الوحدة الخامسة',
          'topics': ['Modal Verbs', 'Giving Advice', 'Health'],
        },
        {
          'titleEn': 'Unit 6',
          'titleAr': 'الوحدة السادسة',
          'topics': ['Passive Voice', 'Science Topics', 'Environment'],
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
          title: Text(
            'اللغة $subjectNameAr',
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
            // ── Subject icon + subtitle ────────────────────────────
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: color),
              ),
            ),
            const SizedBox(height: 14),
            const Center(
              child: Text(
                'اختر الوحدة أو الدرس',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'سأساعدك في فهم قواعد $subjectNameAr',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // ── Unit cards ─────────────────────────────────────────
            ..._units.map((unit) => _UnitTopicsCard(
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

class _UnitTopicsCard extends StatelessWidget {
  final Map<String, dynamic> unit;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String subjectNameAr;

  const _UnitTopicsCard({
    required this.unit,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.subjectNameAr,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> topics = List<String>.from(unit['topics'] as List);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UnderstandChatScreen(
            unitTitleEn: unit['titleEn'] as String,
            unitTitleAr: unit['titleAr'] as String,
            subjectNameAr: subjectNameAr,
            color: color,
            icon: icon,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit['titleEn'] as String,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unit['titleAr'] as String,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'المواضيع:',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  ...topics.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 7, color: color),
                          const SizedBox(width: 8),
                          Text(t,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 3 — AI Chat
// ─────────────────────────────────────────────────────────────────────────────

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}

class UnderstandChatScreen extends StatefulWidget {
  final String unitTitleEn;
  final String unitTitleAr;
  final String subjectNameAr;
  final Color color;
  final IconData icon;

  const UnderstandChatScreen({
    super.key,
    required this.unitTitleEn,
    required this.unitTitleAr,
    required this.subjectNameAr,
    required this.color,
    required this.icon,
  });

  @override
  State<UnderstandChatScreen> createState() => _UnderstandChatScreenState();
}

class _UnderstandChatScreenState extends State<UnderstandChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          "before we explain Can you tell me where is the verb, subject, and object In this sentence : 'I need Motqen everyday.'",
      isUser: true,
    ),
    _ChatMessage(
      text: "The verb is 'need', the subject is 'I', and the object is 'Motqen'.",
      isUser: false,
    ),
    _ChatMessage(
      text:
          "Exactly 👌. This tense is called the Present Simple, and it has several uses. Another tense is the Present Continuous, which adds the idea of an action happening right now, like: 'I am studying now.' Let's explain its structure. Can you tell me who the subject is in the last sentence?",
      isUser: true,
    ),
    _ChatMessage(
      text:
          "Great 👍. For example: 'She plays tennis every Sunday.' Notice that the verb takes an 's' because the subject is 'She'.",
      isUser: false,
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              // AI avatar
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.smart_toy_outlined,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'متقن المدرس - ${widget.unitTitleAr}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    'متصل الآن',
                    style: TextStyle(fontSize: 11, color: Color(0xFF16A34A)),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // ── Messages ───────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _MessageBubble(message: _messages[index]);
                },
              ),
            ),

            // ── Input bar ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              color: AppColors.bgColor,
              child: Row(
                children: [
                  // Mic button
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mic_outlined,
                        color: Colors.grey, size: 22),
                  ),
                  const SizedBox(width: 8),

                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          hintText: 'اكتب سؤالك هنا...',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 14,
            color: isUser ? Colors.white : Colors.black87,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

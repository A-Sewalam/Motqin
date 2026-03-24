import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motqin/utils/app_colors.dart';

class LeaderboardCompetitionsScreen extends StatefulWidget {
  const LeaderboardCompetitionsScreen({super.key});

  @override
  State<LeaderboardCompetitionsScreen> createState() =>
      _LeaderboardCompetitionsScreenState();
}

class _LeaderboardCompetitionsScreenState
    extends State<LeaderboardCompetitionsScreen> {
  int _selectedTab = 0; // 0 = Leaderboard, 1 = Competitions

  // ── Mock Data ────────────────────────────────────────────────────────────────

  final List<Map<String, dynamic>> _leaderboard = [
    {'name': 'أحمد محمد',    'points': '2,850', 'streak': 15, 'avatar': '👨‍🎓'},
    {'name': 'فاطمة علي',    'points': '2,720', 'streak': 12, 'avatar': '👩‍🎓'},
    {'name': 'محمد أحمد',    'points': '2,650', 'streak': 10, 'avatar': '👨‍💻'},
    {'name': 'نور الهدى',    'points': '2,480', 'streak': 8,  'avatar': '👩‍💼'},
    {'name': 'عبدالله سالم', 'points': '2,350', 'streak': 7,  'avatar': '👨‍🎓'},
    {'name': 'مريم خالد',    'points': '2,200', 'streak': 6,  'avatar': '👩‍🏫'},
    {'name': 'يوسف عمر',    'points': '2,100', 'streak': 5,  'avatar': '👨‍🎨'},
    {'name': 'سارة أحمد',    'points': '1,950', 'streak': 4,  'avatar': '👩‍⚕️'},
    {'name': 'خالد محمود',   'points': '1,800', 'streak': 3,  'avatar': '👨‍🔬'},
    {'name': 'ليلى حسن',    'points': '1,650', 'streak': 2,  'avatar': '👩‍💻'},
  ];

  final List<Map<String, dynamic>> _competitions = [
    {
      'title': 'مسابقة الرياضيات الأسبوعية',
      'description': 'تحدى زملاءك في حل المسائل الرياضية',
      'participants': 156,
      'prize': '1000 جنية',
      'daysLeft': 3,
      'buttonColor': const Color(0xFF22C55E),
    },
    {
      'title': 'تحدي اللغة الإنجليزية',
      'description': 'اختبر مهاراتك في القواعد والمفردات',
      'participants': 203,
      'prize': '750 جنية',
      'daysLeft': 5,
      'buttonColor': const Color(0xFF3B82F6),
    },
    {
      'title': 'مسابقة العلوم الشهرية',
      'description': 'استكشف عالم العلوم والاكتشافات',
      'participants': 89,
      'prize': '500 جنية',
      'daysLeft': 12,
      'buttonColor': const Color(0xFF8B5CF6),
    },
  ];

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _rankBadge(int rank) {
    switch (rank) {
      case 1:
        return const Icon(FontAwesomeIcons.crown, color: Color(0xFFFFB300), size: 28);
      case 2:
        return const Icon(FontAwesomeIcons.medal, color: Color(0xFF9E9E9E), size: 28);
      case 3:
        return const Icon(FontAwesomeIcons.medal, color: Color(0xFFCD7F32), size: 28);
      default:
        return SizedBox(
          width: 32,
          child: Text(
            '$rank',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        );
    }
  }

  Color _cardColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFFFFF9B9);
      case 2: return const Color(0xFFF0F0F0);
      case 3: return const Color(0xFFFFE8D0);
      default: return Colors.white;
    }
  }

  Color? _cardBorderColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFFD4A017); // darker gold
      case 2: return const Color(0xFF9E9E9E); // darker silver
      case 3: return const Color(0xFFB5651D); // darker bronze
      default: return null;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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
            'قوائم الصدارة والمسابقات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.appbartitlesColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabSelector(),
              Expanded(
                child: _selectedTab == 0
                    ? _buildLeaderboard()
                    : _buildCompetitions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _tabButton(label: 'قائمة الصدارة', icon: Icons.emoji_events_outlined, index: 0),
            _tabButton(label: 'المسابقات', icon: Icons.star_border, index: 1),
          ],
        ),
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final bool active = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.mainColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: active ? Colors.white : Colors.black54),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Leaderboard Tab ───────────────────────────────────────────────────────

  Widget _buildLeaderboard() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: _leaderboard.length,
      itemBuilder: (context, index) {
        final user = _leaderboard[index];
        final rank = index + 1;
        return _leaderboardCard(user, rank);
      },
    );
  }

  Widget _leaderboardCard(Map<String, dynamic> user, int rank) {
    final borderColor = _cardBorderColor(rank);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardColor(rank),
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(width: 36, child: _rankBadge(rank)),
          const SizedBox(width: 10),

          // Avatar emoji
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                user['avatar'] as String,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & streak
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 3),
                    Text(
                      'سلسلة ${user['streak']} يوم',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user['points']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appbartitlesColor,
                ),
              ),
              const Text(
                'نقطة',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Competitions Tab ──────────────────────────────────────────────────────

  Widget _buildCompetitions() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      itemCount: _competitions.length,
      itemBuilder: (context, index) {
        return _competitionCard(_competitions[index]);
      },
    );
  }

  Widget _competitionCard(Map<String, dynamic> comp) {
    final Color btnColor = comp['buttonColor'] as Color;
    final int days = comp['daysLeft'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with days remaining
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  comp['title'] as String,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    days == 1 ? 'يوم $days' : 'أيام $days',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF97316),
                    ),
                  ),
                  const Text(
                    'متبقي',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            comp['description'] as String,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          // Participants & prize
          Row(
            children: [
              const Icon(Icons.group_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'مشارك ${comp['participants']}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.emoji_events_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'الجائزة النقدية: ${comp['prize']}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'انضم للمسابقة',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

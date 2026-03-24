import 'package:flutter/material.dart';
import 'package:motqin/utils/app_assets.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:motqin/l10n/app_localizations.dart';
import 'package:motqin/utils/app_routes.dart';
import 'package:motqin/widgets/custom_bottom_nav.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);

    switch (index) {
      case 0:
        // Already on home, do nothing
        break;
      case 1:
        Navigator.of(context).pushNamed(AppRoutes.leaderboardCompetitionsRouteName);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoutes.masterYourLessonsRouteName);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoutes.understandYourLessonsRouteName);
        break;
      case 4:
        Navigator.of(context).pushNamed(AppRoutes.blockDistractionsRouteName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // ── Top Row: profile icon ──────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.profileRouteName);
                    },
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: Color(0xFF2563EB),
                      size: 48,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── App Logo ───────────────────────────────────────────
              Image.asset(
                AppAssets.appLogo,
                height: 110,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 12),

              // ── Gradient Divider ───────────────────────────────────
              Container(
                width: 90,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB2D3FF),
                      Color(0xFF2563EB),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Compete / Leaderboards ─────────────────────────────
              _homeButton(
                text: AppLocalizations.of(context)!.leaderboards_and_competitions,
                gradient: const LinearGradient(colors: [Color(0xFFFFF9B9), Color(0xFFFFF377)]),
                textColor: AppColors.leaderboardtextColor,
                icon: AppAssets.iconCompetitions,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.leaderboardCompetitionsRouteName),
              ),

              const SizedBox(height: 18),

              // ── Master Your Lessons ────────────────────────────────
              _homeButton(
                text: AppLocalizations.of(context)!.master_your_lessons,
                gradient: const LinearGradient(colors: [Color(0xFFDAEAFF), Color(0xFFB2D3FF)]),
                textColor: const Color(0xFF2563EB),
                icon: AppAssets.iconMasterYourLessons,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.masterYourLessonsRouteName),
              ),

              const SizedBox(height: 18),

              // ── Understand Your Lessons ────────────────────────────
              _homeButton(
                text: AppLocalizations.of(context)!.understand_your_lessons,
                gradient: const LinearGradient(colors: [Color(0xFFCDFFDE), Color(0xFF9CFFBE)]),
                textColor: const Color(0xFF16A34A),
                icon: AppAssets.iconUnderstandYourLessons,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.understandYourLessonsRouteName),
              ),

              const SizedBox(height: 18),

              // ── Block Distractions ─────────────────────────────────
              _homeButton(
                text: AppLocalizations.of(context)!.block_distractions,
                gradient: const LinearGradient(colors: [Color(0xFFEEDDFF), Color(0xFFDDBFFF)]),
                textColor: const Color(0xFF7C3AED),
                icon: AppAssets.iconBlockDisractions,
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.blockDistractionsRouteName),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeButton({
    required String text,
    required LinearGradient gradient,
    required Color textColor,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 27),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Text perfectly centered across full button width
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            // Icon pinned to the left
            Positioned(
              left: 0,
              child: Image.asset(icon, width: 42, height: 42),
            ),
          ],
        ),
      ),
    );
  }
}

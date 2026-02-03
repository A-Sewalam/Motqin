import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/app_language_provider.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<AppLanguageProvider>();
    final isArabic = langProvider.appLanguage == 'ar';
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tabsBgColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35))
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: isArabic ? 'الرئيسية' : 'Home',
                index: 0,
                isActive: ,
                color: AppColors.homeTabColor,
              ),
              _buildNavItem(
                context,
                icon: Icons.emoji_events_outlined,
                activeIcon: Icons.emoji_events,
                label: isArabic ? 'المسابقات' : 'Compete',
                index: 1,
                isActive: ,
                color: AppColors.competeTabColor,
              ),
              _buildNavItem(
                context,
                icon: Icons.star_outline,
                activeIcon: Icons.star,
                label: isArabic ? 'اتقن' : 'Master',
                index: 2,
                isActive: ,
                color: AppColors.masterTabColor,
              ),
              _buildNavItem(
                context,
                icon: Icons.school_outlined,
                activeIcon: Icons.school,
                label: isArabic ? 'افهم' : 'Learn',
                index: 3,
                isActive: ,
                color: AppColors.learnTabColor
              ),
              _buildNavItem(
                context,
                icon: Icons.block_outlined,
                activeIcon: Icons.block,
                label: isArabic ? 'التركيز' : 'Focus',
                index: 4,
                isActive: ,
                color: AppColors.focusTabColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? color : Colors.grey,
              size: isActive ? 30 : 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isActive ? 12 : 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
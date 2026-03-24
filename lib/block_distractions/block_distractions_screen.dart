import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';
import 'restrict_app_usage_widget.dart';
import 'block_options_widget.dart';
import 'admin_settings_widget.dart';
import 'study_timer_widget.dart';

class BlockDistractionsScreen extends StatefulWidget {
  const BlockDistractionsScreen({super.key});

  @override
  State<BlockDistractionsScreen> createState() => _BlockDistractionsScreenState();
}

class _BlockDistractionsScreenState extends State<BlockDistractionsScreen> {
  bool _allBlocked = false;

  void _onToggleBlock(bool blocked) {
    setState(() => _allBlocked = blocked);
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
          centerTitle: true,
          title: const Text(
            'منع المشتتات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.appbartitlesColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RestrictAppUsageWidget(allBlocked: _allBlocked),
              const SizedBox(height: 20),
              BlockOptionsWidget(onToggleBlock: _onToggleBlock),
              const SizedBox(height: 20),
              const AdminSettingsWidget(),
              const SizedBox(height: 20),
              const StudyTimerWidget(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

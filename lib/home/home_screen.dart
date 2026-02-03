import 'package:flutter/material.dart';
import 'package:motqin/providers/app_language_provider.dart';
import 'package:motqin/utils/app_assets.dart';
import 'package:motqin/utils/app_colors.dart';
// import 'package:motqin/utils/app_routes.dart';
import 'package:motqin/l10n/app_localizations.dart';
import 'package:motqin/utils/app_routes.dart';
import 'package:provider/provider.dart';
// import '../providers/app_navigation_provider.dart';
import 'custom_home_buttons.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);


    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(languageProvider.appLanguage == 'en'){
          languageProvider.changeLanguage('ar');
        } else {
          languageProvider.changeLanguage('en');
        }
        setState((){});
        },
        child: Icon(Icons.translate_outlined),
      ),
      body:
      SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Home Buttons
              customHomeButton(
                context,
                text: AppLocalizations.of(context)!.leaderboards_and_competitions,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFF9B9), Color(0xFFFFF377)],
            
                ),
                textColor: AppColors.leaderboardtextColor,
                icon: AppAssets.iconCompetitions,
                onTap: () {
                  Provider.of(context).pushNamed(AppRoutes.leaderboardCompetitionsRouteName);
                },
              ),
              SizedBox(height: 20),
              
              customHomeButton(
                context,
                text: AppLocalizations.of(context)!.master_your_lessons,
                gradient: LinearGradient(
                  colors: [Color(0xFFCDFFDE), Color(0xFF9CFFBE)],
            
                ),
                textColor: Color(0xFF16A34A),
            
                icon: AppAssets.iconMasterYourLessons,
                onTap: () {
                  Provider.of(context).pushNamed(AppRoutes.masterYourLessonsRouteName);
                 
                },
              ),
              SizedBox(height: 20),
              
              customHomeButton(
                context,
                text: AppLocalizations.of(context)!.understand_your_lessons,
                gradient: LinearGradient(
                  colors: [Color(0xFFDAEAFF), Color(0xFFB2D3FF)],
            
                ),
                textColor: Color(0xFF2563EB),
                icon: AppAssets.iconUnderstandYourLessons,
                onTap: () {
                  Provider.of(context).pushNamed(AppRoutes.understandYourLessonsRouteName);

                },
              ),
              SizedBox(height: 20),
              
              customHomeButton(
                context,
                text: AppLocalizations.of(context)!.block_distractions,
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD3D3), Color(0xFFFFB2B2)],
                ),
                textColor: Color(0xFFE91E63),
                icon: AppAssets.iconBlockDisractions,
                onTap: () {
                  Provider.of(context).pushNamed(AppRoutes.blockDistractionsRouteName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

              // // Progress Card
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.all(24),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
              //     ),
              //     borderRadius: BorderRadius.circular(20),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Color(0xFF64B5F6).withOpacity(0.3),
              //         blurRadius: 15,
              //         offset: Offset(0, 5),
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         child: Text(
              //           'خطتك اليومية\nشبه منتهية!',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //             height: 1.4,
              //           ),
              //         ),
              //       ),
              //       Stack(
              //         alignment: Alignment.center,
              //         children: [
              //           SizedBox(
              //             width: 70,
              //             height: 70,
              //             child: CircularProgressIndicator(
              //               value: 0.85,
              //               strokeWidth: 8,
              //               backgroundColor: Colors.white.withOpacity(0.3),
              //               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              //             ),
              //           ),
              //           Text(
              //             '85%',
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 18,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 20),

            //    IconButton( 
            // onPressed: (){
            //   Navigator.of(context).pushNamed(AppRoutes.profileRouteName);
            // }, 
            // icon: CircleAvatar(
            //   backgroundColor: AppColors.whiteColor,
            //   child: Icon(Icons.person_2_outlined, color: AppColors.profileIconColor,),
            //   ),
            // ),
              
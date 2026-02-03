import 'package:flutter/material.dart';
import 'package:motqin/home/home_screen.dart';
import 'package:motqin/home/profile_screen.dart';
import 'package:motqin/auth/login/login_screen.dart';
import 'package:motqin/providers/app_language_provider.dart';
import 'package:motqin/providers/app_theme_provider.dart';
import 'package:motqin/utils/app_routes.dart';
import 'package:motqin/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'auth/signup/signup_screen.dart';
import 'leaderboard_competitions/leaderboard_competitions_screen.dart';
import 'master_lessons/master_lessons_screen.dart';
import 'understand_lessons/understand_lessons_screen.dart';
import 'block_distractions/block_distractions_screen.dart';
//import 'package:toggle_switch/toggle_switch.dart';



void main (){
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
      create: (context) => AppLanguageProvider(),),
     ChangeNotifierProvider(
      create: (context) => AppThemeProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginRouteName,
      routes: {
        AppRoutes.loginRouteName : (context) => LoginScreen(),
        AppRoutes.homeRouteName : (context) => HomeScreen(),
        AppRoutes.profileRouteName: (context) => ProfileScreen(),
        AppRoutes.signupRouteName : (context) => SignupScreen(),
        AppRoutes.leaderboardCompetitionsRouteName : (context) => LeaderboardCompetitionsScreen(),
        AppRoutes.masterYourLessonsRouteName : (context) => MasterLessonsScreen(),
        AppRoutes.understandYourLessonsRouteName : (context) => UnderstandLessonsScreen(),
        AppRoutes.blockDistractionsRouteName : (context) => BlockDistractionsScreen(),
      },
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageProvider.appLanguage),
    );
  }
}
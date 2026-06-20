import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'auth/verify_email/verify_email_screen.dart';
import 'leaderboard_competitions/leaderboard_competitions_screen.dart';
import 'master_lessons/master_lessons_screen.dart';
import 'understand_lessons/understand_lessons_screen.dart';
import 'block_distractions/block_distractions_screen.dart';
import 'core/di/service_locator.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up all services and blocs via get_it
  await setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<AppLanguageProvider>(context);
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckStatusRequested()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.loginRouteName,
        routes: {
          AppRoutes.loginRouteName:                   (_) => const LoginScreen(),
          AppRoutes.homeRouteName:                    (_) => const HomeScreen(),
          AppRoutes.profileRouteName:                 (_) => const ProfileScreen(),
          AppRoutes.signupRouteName:                  (_) => const SignupScreen(),
          AppRoutes.verifyEmailRouteName:             (_) => const VerifyEmailScreen(),
          AppRoutes.leaderboardCompetitionsRouteName: (_) => const LeaderboardCompetitionsScreen(),
          AppRoutes.masterYourLessonsRouteName:       (_) => const MasterLessonsScreen(),
          AppRoutes.understandYourLessonsRouteName:   (_) => const UnderstandLessonsScreen(),
          AppRoutes.blockDistractionsRouteName:       (_) => const BlockDistractionsScreen(),
        },
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.appTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(languageProvider.appLanguage),
      ),
    );
  }
}

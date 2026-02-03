import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:motqin/utils/app_styles.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.transparentColor,
  );
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.bgColor,
    textTheme: TextTheme(
      headlineLarge: AppStyles.bold16Black,
      labelLarge: AppStyles.semi24MainColor,
    ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   selectedItemColor: Colors.black,
    //   unselectedItemColor: Colors.blue,
    //   backgroundColor: Colors.red
    // )

    )
  ;
}
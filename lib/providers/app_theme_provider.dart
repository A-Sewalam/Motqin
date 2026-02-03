import 'package:flutter/material.dart';

class AppThemeProvider extends ChangeNotifier{
  ThemeMode appTheme = ThemeMode.light;

  void changeAppTheme(ThemeMode newTheme){

    if(appTheme == newTheme){
      return ;
    }
    appTheme = newTheme;
    notifyListeners();
  } 


  bool isDarkMode(){
    appTheme == ThemeMode.dark;
    return true;
  }
}
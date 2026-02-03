import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motqin/l10n/app_localizations.dart';
import 'package:motqin/providers/app_language_provider.dart';
import 'package:motqin/providers/app_theme_provider.dart';
import 'package:motqin/utils/app_assets.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:motqin/utils/app_routes.dart';
import 'package:motqin/utils/app_styles.dart';
import 'package:motqin/widgets/custom_elevated_button.dart';
import 'package:motqin/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var languageProvider = Provider.of<AppLanguageProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppAssets.appLogo, height: height * .1),
        centerTitle: true,
        toolbarHeight: height * .15,
        backgroundColor: AppColors.bgColor,
      ),
      floatingActionButton: FloatingActionButton(onPressed: 
      (){
        if(languageProvider.appLanguage == 'en'){
          languageProvider.changeLanguage('ar');
        } else {
          languageProvider.changeLanguage('en');
        }
        setState((){});
      },
      child: Icon(Icons.translate_outlined),),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.02,
        ),
        child: Column(
          spacing: height * 0.02,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.login_to_your_account,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            CustomTextField(
              filled: themeProvider.appTheme == ThemeMode.light ? true : false,
              fillColor: AppColors.whiteColor,
              borderColor: themeProvider.appTheme == ThemeMode.light
                  ? AppColors.strokeWhiteColor
                  : AppColors.whiteColor,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: themeProvider.appTheme == ThemeMode.light
                    ? AppColors.lightGreyColor
                    : AppColors.whiteColor,
                size: 25,
              ),
              suffixIcon: null,
              hintText: AppLocalizations.of(context)!.enter_your_email,
              hintStyle: AppStyles.regular14greyColor,
            ),

            CustomTextField(
              filled: themeProvider.appTheme == ThemeMode.light ? true : false,
              fillColor: AppColors.whiteColor,
              borderColor: themeProvider.appTheme == ThemeMode.light
                  ? AppColors.strokeWhiteColor
                  : AppColors.whiteColor,
              prefixIcon: Icon(
                Icons.lock_outlined,
                color: themeProvider.appTheme == ThemeMode.light
                    ? AppColors.lightGreyColor
                    : AppColors.whiteColor,
                size: 25,
              ),
              suffixIcon: Icon(
                Icons.visibility_off_outlined,
                color: themeProvider.appTheme == ThemeMode.light
                    ? AppColors.lightGreyColor
                    : AppColors.whiteColor,
                size: 25,
              ),
              hintText: AppLocalizations.of(context)!.enter_your_password,
              hintStyle: AppStyles.regular14greyColor,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.forget_password,
                    style: AppStyles.semi14MainColor.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onpressed: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.homeRouteName);
                },
                backgroundColor: AppColors.mainColor,
                icon: Icon(Icons.login_outlined, color: AppColors.whiteColor),
                label: Text(
                  AppLocalizations.of(context)!.login,
                  style: AppStyles.medium20White,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.dont_have_an_account,
                  style: AppStyles.regular14greyColor,
                ),
                TextButton(
                  onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.signupRouteName);

                  },
                  child: Text(
                    AppLocalizations.of(context)!.sign_up,
                    style: AppStyles.semi14MainColor.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.lightGreyColor,
                    thickness: 2,
                    indent: width * 0.02,
                    endIndent: width * 0.06,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.or,
                  style: AppStyles.medium16MainColor,
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.lightGreyColor,
                    thickness: 2,
                    indent: width * 0.06,
                    endIndent: width * 0.02,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                backgroundColor: AppColors.whiteColor,
                onpressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.signupRouteName);
                },
                label: Text(
                  AppLocalizations.of(context)!.sign_up_with_google,
                  style: AppStyles.medium16MainColor,
                ),
                icon:Image.asset(AppAssets.googleLogo, height: 24, width: 24)
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                backgroundColor: AppColors.whiteColor,
                onpressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.signupRouteName);
                },
                label: Text(
                  AppLocalizations.of(context)!.sign_up_with_facebook,
                  style: AppStyles.medium16MainColor,
                ),
                icon: Icon(FontAwesomeIcons.facebook, color: Colors.blue),
              ),
            ),

          ],
        ),
      ),
    ),
    );
  }
}

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
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
// import 'package:motqin/features/auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    // TODO: uncomment when APIs are ready
    // if (!_formKey.currentState!.validate()) return;
    // context.read<AuthBloc>().add(AuthLoginRequested(
    //   email: _emailController.text.trim(),
    //   password: _passwordController.text,
    // ));
    Navigator.of(context).pushReplacementNamed(AppRoutes.homeRouteName);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;
    final themeProvider    = Provider.of<AppThemeProvider>(context);
    final languageProvider = Provider.of<AppLanguageProvider>(context);

    // TODO: uncomment when APIs are ready
    // return BlocListener<AuthBloc, AuthState>(
    //   listener: (context, state) {
    //     if (state is AuthAuthenticated) {
    //       Navigator.of(context).pushReplacementNamed(AppRoutes.homeRouteName);
    //     }
    //     if (state is AuthError) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text(state.message), backgroundColor: Colors.red),
    //       );
    //     }
    //   },
    //   child:
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          languageProvider.changeLanguage(
            languageProvider.appLanguage == 'en' ? 'ar' : 'en',
          );
          setState(() {});
        },
        child: const Icon(Icons.translate_outlined),
      ),
      // TODO: wrap with BlocBuilder<AuthBloc, AuthState> when APIs are ready
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          // TODO: wrap with Form(key: _formKey) when APIs are ready
          child: Column(
            spacing: height * 0.02,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ──────────────────────────────────────────────────────
              SizedBox(height: height * 0.03),
              Center(
                child: Image.asset(
                  AppAssets.appLogo,
                  height: height * 0.12,
                  fit: BoxFit.contain,
                ),
              ),

              // ── Title ─────────────────────────────────────────────────────
              Text(
                AppLocalizations.of(context)!.login_to_your_account,
                style: Theme.of(context).textTheme.labelLarge,
              ),

              
              // ── Email field ───────────────────────────────────────────────
              CustomTextField(
                controller: _emailController,
                filled: themeProvider.appTheme == ThemeMode.light,
                fillColor: AppColors.whiteColor,
                borderColor: themeProvider.appTheme == ThemeMode.light
                    ? AppColors.strokeWhiteColor
                    : AppColors.whiteColor,
                prefixIcon: Icon(Icons.email_outlined,
                    color: themeProvider.appTheme == ThemeMode.light
                        ? AppColors.lightGreyColor
                        : AppColors.whiteColor,
                    size: 25),
                suffixIcon: null,
                hintText: AppLocalizations.of(context)!.enter_your_email,
                hintStyle: AppStyles.regular14greyColor,
                keyboardType: TextInputType.emailAddress,
                // validator: (v) => v == null || v.isEmpty ? 'يرجى إدخال البريد الإلكتروني' : null,
              ),

              // ── Password field ────────────────────────────────────────────
              CustomTextField(
                controller: _passwordController,
                filled: themeProvider.appTheme == ThemeMode.light,
                fillColor: AppColors.whiteColor,
                borderColor: themeProvider.appTheme == ThemeMode.light
                    ? AppColors.strokeWhiteColor
                    : AppColors.whiteColor,
                prefixIcon: Icon(Icons.lock_outlined,
                    color: themeProvider.appTheme == ThemeMode.light
                        ? AppColors.lightGreyColor
                        : AppColors.whiteColor,
                    size: 25),
                suffixIcon: GestureDetector(
                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: themeProvider.appTheme == ThemeMode.light
                        ? AppColors.lightGreyColor
                        : AppColors.whiteColor,
                    size: 25,
                  ),
                ),
                obscureText: _obscurePassword,
                hintText: AppLocalizations.of(context)!.enter_your_password,
                hintStyle: AppStyles.regular14greyColor,
                // validator: (v) => v == null || v.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
              ),

              // ── Forget password ───────────────────────────────────────────
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

              // ── Login button ──────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onpressed: _onLoginPressed,
                  backgroundColor: AppColors.mainColor,
                  icon: Icon(Icons.login_outlined, color: AppColors.whiteColor),
                  label: Text(
                    AppLocalizations.of(context)!.login,
                    style: AppStyles.medium20White,
                  ),
                ),
              ),

              // ── Don't have account ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.dont_have_an_account,
                    style: AppStyles.regular14greyColor,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.signupRouteName),
                    child: Text(
                      AppLocalizations.of(context)!.sign_up,
                      style: AppStyles.semi14MainColor.copyWith(
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),


              // ── Divider ───────────────────────────────────────────────────
              Row(children: [
                Expanded(
                    child: Divider(
                        color: AppColors.lightGreyColor,
                        thickness: 2,
                        indent: width * 0.02,
                        endIndent: width * 0.06)),
                Text(AppLocalizations.of(context)!.or,
                    style: AppStyles.medium16MainColor),
                Expanded(
                    child: Divider(
                        color: AppColors.lightGreyColor,
                        thickness: 2,
                        indent: width * 0.06,
                        endIndent: width * 0.02)),
              ]),


              // ── Facebook ──────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  backgroundColor: AppColors.whiteColor,
                  onpressed: () {},
                  label: Text(
                    AppLocalizations.of(context)!.sign_up_with_facebook,
                    style: AppStyles.medium16MainColor,
                  ),
                  icon: const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                ),
              ),

              // ── Google ────────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  backgroundColor: AppColors.whiteColor,
                  onpressed: () => Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.verifyEmailRouteName),
                  label: Text(
                    AppLocalizations.of(context)!.sign_up_with_google,
                    style: AppStyles.medium16MainColor,
                  ),
                  icon: Image.asset(AppAssets.googleLogo, height: 19, width: 19),
                ),
              ),

            ],
          ),
        ),
      ),
    ); // uncomment closing parenthesis for BlocListener when APIs are ready
  }
}

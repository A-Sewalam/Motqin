import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:motqin/features/auth/bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController            = TextEditingController();
  final _emailController           = TextEditingController();
  final _passwordController        = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey                   = GlobalKey<FormState>();
  bool _obscurePassword            = true;
  bool _obscureConfirm             = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthRegisterRequested(
      userName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: 'Student', // default role; can be made a dropdown later
    ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;
    final themeProvider    = Provider.of<AppThemeProvider>(context);
    final languageProvider = Provider.of<AppLanguageProvider>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // After successful registration, go to email verification screen
        if (state is AuthRegistrationSuccess) {
          Navigator.of(context).pushNamed(
            AppRoutes.verifyEmailRouteName,
            arguments: state.email,
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            languageProvider.changeLanguage(
              languageProvider.appLanguage == 'en' ? 'ar' : 'en',
            );
          },
          child: const Icon(Icons.translate_outlined),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.02,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: height * 0.02,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03),

                      Center(
                        child: Image.asset(
                          AppAssets.appLogo,
                          height: height * 0.12,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Text(
                        AppLocalizations.of(context)!.create_your_account,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),

                      // Name
                      CustomTextField(
                        controller: _nameController,
                        filled: themeProvider.appTheme == ThemeMode.light,
                        fillColor: AppColors.whiteColor,
                        borderColor: themeProvider.appTheme == ThemeMode.light
                            ? AppColors.strokeWhiteColor
                            : AppColors.whiteColor,
                        prefixIcon: Icon(Icons.person_2_outlined,
                            color: themeProvider.appTheme == ThemeMode.light
                                ? AppColors.lightGreyColor
                                : AppColors.whiteColor,
                            size: 25),
                        suffixIcon: null,
                        hintText: AppLocalizations.of(context)!.enter_your_name,
                        hintStyle: AppStyles.regular14greyColor,
                        validator: (v) => v == null || v.isEmpty
                            ? 'يرجى إدخال الاسم'
                            : null,
                      ),

                      // Email
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
                        validator: (v) => v == null || v.isEmpty
                            ? 'يرجى إدخال البريد الإلكتروني'
                            : null,
                      ),

                      // Password
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
                          onTap: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
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
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                          if (v.length < 8) return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                          return null;
                        },
                      ),

                      // Confirm password
                      CustomTextField(
                        controller: _confirmPasswordController,
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
                          onTap: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                          child: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: themeProvider.appTheme == ThemeMode.light
                                ? AppColors.lightGreyColor
                                : AppColors.whiteColor,
                            size: 25,
                          ),
                        ),
                        obscureText: _obscureConfirm,
                        hintText: AppLocalizations.of(context)!.confirm_your_password,
                        hintStyle: AppStyles.regular14greyColor,
                        validator: (v) => v != _passwordController.text
                            ? 'كلمتا المرور غير متطابقتين'
                            : null,
                      ),

                      // Sign up button
                      SizedBox(
                        width: double.infinity,
                        child: state is AuthLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomElevatedButton(
                                onpressed: _onSignupPressed,
                                backgroundColor: AppColors.mainColor,
                                icon: Icon(Icons.person_add_outlined,
                                    color: AppColors.whiteColor),
                                label: Text(
                                  AppLocalizations.of(context)!.sign_up,
                                  style: AppStyles.medium20White,
                                ),
                              ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.already_have_an_account,
                            style: AppStyles.regular14greyColor,
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.loginRouteName),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: AppStyles.semi14MainColor.copyWith(
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),

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


                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          backgroundColor: AppColors.whiteColor,
                          onpressed: () {},
                          label: Text(
                            AppLocalizations.of(context)!.sign_up_with_facebook,
                            style: AppStyles.medium16MainColor,
                          ),
                          icon: const Icon(FontAwesomeIcons.facebook,
                              color: Colors.blue),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          backgroundColor: AppColors.whiteColor,
                          onpressed: () {},
                          label: Text(
                            AppLocalizations.of(context)!.sign_up_with_google,
                            style: AppStyles.medium16MainColor,
                          ),
                          icon: Image.asset(AppAssets.googleLogo, height: 19, width: 19),

                      ),)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

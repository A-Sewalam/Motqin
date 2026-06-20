import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motqin/utils/app_colors.dart';
import 'package:motqin/utils/app_routes.dart';
import 'package:motqin/utils/app_styles.dart';
import 'package:motqin/widgets/custom_elevated_button.dart';
import 'package:motqin/widgets/custom_text_field.dart';
import 'package:motqin/features/auth/bloc/auth_bloc.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onVerifyPressed(String email) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthVerifyEmailRequested(
      email: email,
      code: _codeController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Email is passed as a route argument from signup screen
    final email = ModalRoute.of(context)!.settings.arguments as String? ?? '';
    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthEmailVerified) {
          // After verification, go to login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم التحقق من البريد الإلكتروني بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.loginRouteName);
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
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          elevation: 0,
          title: const Text('التحقق من البريد الإلكتروني'),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.04,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.mark_email_read_outlined,
                          size: 80, color: AppColors.mainColor),
                      SizedBox(height: height * 0.03),
                      Text(
                        'تم إرسال رمز التحقق إلى',
                        style: AppStyles.regular14greyColor,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.01),
                      Text(
                        email,
                        style: AppStyles.semi14MainColor,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.04),
                      CustomTextField(
                        controller: _codeController,
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        borderColor: AppColors.strokeWhiteColor,
                        prefixIcon: const Icon(Icons.lock_outlined,
                            color: AppColors.lightGreyColor, size: 25),
                        suffixIcon: null,
                        hintText: 'أدخل رمز التحقق',
                        hintStyle: AppStyles.regular14greyColor,
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty
                            ? 'يرجى إدخال رمز التحقق'
                            : null,
                      ),
                      SizedBox(height: height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        child: state is AuthLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomElevatedButton(
                                onpressed: () => _onVerifyPressed(email),
                                backgroundColor: AppColors.mainColor,
                                icon: const Icon(Icons.verified_outlined,
                                    color: Colors.white),
                                label: const Text(
                                  'تحقق',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
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

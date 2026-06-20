import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  bool? filled;
  Color? fillColor;
  Color borderColor;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String? hintText;
  TextStyle? hintStyle;
  String? labelText;
  TextStyle? labelStyle;

  // Added fields needed for form validation and input handling
  TextEditingController? controller;
  bool obscureText;
  TextInputType? keyboardType;
  String? Function(String?)? validator;

  CustomTextField({
    super.key,
    this.filled,
    this.fillColor,
    required this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: builtDecoratedBorder(
          borderColor: borderColor,
          borderRadius: 16,
        ),
        focusedBorder: builtDecoratedBorder(
          borderColor: borderColor,
          borderRadius: 16,
        ),
        errorBorder: builtDecoratedBorder(
          borderColor: AppColors.redColor,
          borderRadius: 16,
        ),
        focusedErrorBorder: builtDecoratedBorder(
          borderColor: AppColors.redColor,
          borderRadius: 16,
        ),
        filled: filled,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
      ),
    );
  }

  OutlineInputBorder builtDecoratedBorder({
    required Color borderColor,
    required double borderRadius,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor, width: 2.0),
    );
  }
}

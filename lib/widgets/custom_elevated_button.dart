import 'package:flutter/material.dart';
import 'package:motqin/utils/app_colors.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  VoidCallback onpressed;
  Widget label;
  Color? backgroundColor;
  Widget? icon;

  CustomElevatedButton({super.key,
  required this.onpressed,
  required this.label,
  this.backgroundColor,
  this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          vertical: height * 0.01,
        ),
      ),
      onPressed: onpressed,
      icon: icon,
      label: label ,
    );
  }
}
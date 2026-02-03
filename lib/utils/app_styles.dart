import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motqin/utils/app_colors.dart';

class AppStyles {
  static final TextStyle bold16White = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor
  );
  static final TextStyle medium20White = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.whiteColor
  );

   static final TextStyle bold16Black = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor
  );

    static final TextStyle semi24White= GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.whiteColor
    );

    static final TextStyle semi24MainColor= GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.mainColor
    );

    static final TextStyle semi14MainColor= GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.mainColor
    );

    static final TextStyle regular14MainColor= GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.mainColor
    );

    static final TextStyle medium16MainColor= GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.mainColor
    );

    static final TextStyle medium20MainColor= GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.mainColor
    );

    static final TextStyle regular14greyColor= GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightGreyColor
    );
}
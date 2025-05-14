import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Responsive headline
  static TextStyle title = GoogleFonts.dosis(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  static TextStyle webAppbarItems = GoogleFonts.dosis(
    fontSize: 4.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  static TextStyle webListHeading = GoogleFonts.dosis(
    fontSize: 6.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static TextStyle webListViewAll = GoogleFonts.dosis(
      fontSize: 4.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
      decoration: TextDecoration.underline);
  static TextStyle productPriceNormal = GoogleFonts.dosis(
    fontSize: 4.5.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
  static TextStyle productPriceSale = GoogleFonts.dosis(
      fontSize: 4.5.sp,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade500,
      decoration: TextDecoration.lineThrough);
  static TextStyle productPriceSaleDetail = GoogleFonts.dosis(
      fontSize: 7.sp,
      fontWeight: FontWeight.bold,
      color: Colors.grey.shade500,
      decoration: TextDecoration.lineThrough,
      decorationColor: Colors.grey.shade500);
  static TextStyle productPriceSaleMobile = GoogleFonts.dosis(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade500,
      decoration: TextDecoration.lineThrough);
  static TextStyle productPriceSaleTablet = GoogleFonts.dosis(
      fontSize: 7.5.sp,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade500,
      decoration: TextDecoration.lineThrough);
  static TextStyle hereTextNewsLetter = GoogleFonts.dosis(
      fontSize: 4.sp,
      color: Colors.blueAccent,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: Colors.blueAccent);

  // Dynamic style method
  static TextStyle dynamicStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.dosis(
      fontSize: fontSize?.sp ?? 16.sp,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? AppColors.textLight,
    );
  }
}

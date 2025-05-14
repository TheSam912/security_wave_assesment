import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class W_TextFieldWidget extends StatelessWidget {
  const W_TextFieldWidget({
    super.key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.inputType,
    required this.controller,
    required this.obscureText,
    required this.isWeb,
    required this.isTablet,
  });

  final String title;
  final String hint;
  final String icon;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool obscureText;
  final bool isWeb;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              title,
              style: AppTextStyles.dynamicStyle(
                fontSize:
                    isWeb
                        ? 1.sp
                        : isTablet
                        ? 3.8.sp
                        : 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 9,
                  child: TextField(
                    controller: controller,
                    keyboardType: inputType,
                    obscureText: obscureText,
                    style: AppTextStyles.dynamicStyle(
                      fontSize:
                          isWeb
                              ? 1.sp
                              : isTablet
                              ? 3.5.sp
                              : 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      labelStyle: AppTextStyles.dynamicStyle(
                        fontSize: 1.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      hintText: hint,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    width: 30,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Image.asset(icon, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

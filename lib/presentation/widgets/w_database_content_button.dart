import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../dialogs/w_database_content_bottom_sheet.dart';

customFetchDatabaseButton(context) => GestureDetector(
  onTap: () => showUsersFromHive(context),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.primary,
    ),
    child: Text(
      "Database Content is here !",
      style: AppTextStyles.dynamicStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
);
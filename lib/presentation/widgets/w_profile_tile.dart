import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:security_wave/model/user_model.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../provider/auth_provider.dart';
import '../dialogs/w_download_image_dialog.dart';
import '../dialogs/w_edit_bottom_sheet.dart';

class ProfileTile extends ConsumerWidget {
  ProfileTile({super.key, required this.user});

  UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                GestureDetector(
                  onTap:
                      () => downloadImageDialog(context, user.profileImageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CachedNetworkImage(
                      imageUrl: user.profileImageUrl,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  user.email,
                  style: AppTextStyles.dynamicStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ),
          Positioned(
            left: 10,
            child: IconButton(
              onPressed: () => editProfileBottomSheet(context, ref, user),
              icon: Icon(Icons.menu, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

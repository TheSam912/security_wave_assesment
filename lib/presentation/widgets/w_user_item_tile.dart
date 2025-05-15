import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:security_wave/model/user_model.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../provider/auth_provider.dart';
import '../dialogs/w_delete_dialog.dart';
import '../dialogs/w_update_dialog.dart';

class UserItemTile extends ConsumerWidget {
  final UserModel user;

  const UserItemTile({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              showUpdateProfileDialog(
                context,
                uid: user.uid,
                initialEmail: user.email,
                profileImageUrl: user.profileImageUrl,
                onUpdate: (email, newImageUrl) async {
                  try {
                    await ref
                        .read(authRepositoryProvider)
                        .updateUserProfile(
                          uid: user.uid,
                          email: email,
                          profileImageUrl: newImageUrl,
                        );
                    print("User updated.");
                    ref.invalidate(allUsersProvider);
                  } catch (e) {
                    print("Update failed: $e");
                  }
                },
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) {
              showDeleteConfirmationDialog(context, () async {
                try {
                  await ref
                      .read(authRepositoryProvider)
                      .deleteUserById(user.uid);
                  print('User deleted');
                  ref.invalidate(allUsersProvider);
                } catch (e) {
                  print("Delete failed: $e");
                }
              });
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white70,
                    backgroundImage: NetworkImage(user.profileImageUrl),
                  ),
                ),
                Text(
                  user.email,
                  style: AppTextStyles.dynamicStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.keyboard_arrow_right, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

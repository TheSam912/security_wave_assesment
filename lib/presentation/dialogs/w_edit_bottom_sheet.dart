import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:security_wave/presentation/dialogs/w_delete_dialog.dart';
import 'package:security_wave/presentation/dialogs/w_update_dialog.dart';

import '../../core/app_colors.dart';
import '../../model/user_model.dart';
import '../../provider/auth_provider.dart';

editProfileBottomSheet(BuildContext context, WidgetRef ref, UserModel user) =>
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 100,
          color: AppColors.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _editAction(context, ref, user);
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("Edit Account"),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _deleteAction(context, ref, user);
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("Delete Account"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

_editAction(BuildContext context, WidgetRef ref, UserModel user) {
  return showUpdateProfileDialog(
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
      } catch (e) {
        print("Update failed: $e");
      }
    },
  );
}

_deleteAction(BuildContext context, WidgetRef ref, UserModel user) {
  showDeleteConfirmationDialog(context, () async {
    try {
      await ref.read(authRepositoryProvider).deleteUserById(user.uid);
      print('User deleted');
    } catch (e) {
      print("Delete failed: $e");
    }
  });
}

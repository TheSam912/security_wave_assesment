import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../core/app_colors.dart';
import '../../model/user_model.dart';
import '../../provider/auth_provider.dart';
import '../dialogs/w_delete_dialog.dart';
import '../dialogs/w_update_dialog.dart';

Widget userCard(
  BuildContext context,
  WidgetRef ref,
  AsyncValue<UserModel?> authState,
) {
  return authState.when(
    data: (user) {
      if (user == null) return const Text("Not logged in");

      return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            _editAction(context, ref, user),
            _deleteAction(context, ref, user),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              _userAvatar(user.profileImageUrl),
              const SizedBox(width: 8),
              Text("Email: ${user.email}"),
            ],
          ),
        ),
      );
    },
    loading:
        () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
    error: (e, _) => Text("Error: $e"),
  );
}

Widget _userAvatar(String? imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: CachedNetworkImage(
      imageUrl: imageUrl ?? "",
      fit: BoxFit.cover,
      width: 60,
      height: 60,
    ),
  );
}

SlidableAction _editAction(
  BuildContext context,
  WidgetRef ref,
  UserModel user,
) {
  return SlidableAction(
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
  );
}

SlidableAction _deleteAction(
  BuildContext context,
  WidgetRef ref,
  UserModel user,
) {
  return SlidableAction(
    onPressed: (context) {
      showDeleteConfirmationDialog(context, () async {
        try {
          await ref.read(authRepositoryProvider).deleteUserById(user.uid);
          print('User deleted');
        } catch (e) {
          print("Delete failed: $e");
        }
      });
    },
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    icon: Icons.delete_outline,
    label: 'Delete',
  );
}

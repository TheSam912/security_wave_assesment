import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../model/user_model.dart';

void showUsersFromHive(BuildContext context) {
  final box = Hive.box<UserModel>('usersbox');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return ListView.builder(
            controller: scrollController,
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index);
              final user = box.get(key);

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user?.profileImageUrl ?? ''),
                ),
                title: Text(user?.email ?? 'No email'),
                subtitle: Text('Role: ${user?.role ?? 'unknown'}'),
                trailing: Text((key as String).substring(0, 6)),
              );
            },
          );
        },
      );
    },
  );
}

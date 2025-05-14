import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:security_wave/model/user_model.dart';
import 'package:security_wave/presentation/widgets/w_users_box.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../provider/auth_provider.dart';
import '../dialogs/w_delete_dialog.dart';
import '../dialogs/w_update_dialog.dart';
import '../widgets/w_user_card.dart';

class Home_Page extends ConsumerStatefulWidget {
  const Home_Page({super.key});

  @override
  ConsumerState<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends ConsumerState<Home_Page> {
  UserModel? user;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final allUsers = ref.watch(allUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: _customAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userCard(context, ref, authState),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
            child: Text(
              "Users List:",
              style: AppTextStyles.dynamicStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          allUsers.when(
            data: (users) {
              final currentUserEmail = user?.email.toLowerCase();
              final filteredUsers =
                  users
                      .where((u) => u.email.toLowerCase() != currentUserEmail)
                      .toList();

              return ListView.builder(
                itemCount: filteredUsers.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final u = filteredUsers[index];
                  return UserBox(user: u);
                },
              );
            },
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
            error: (e, _) => Text("Error: $e"),
          ),
        ],
      ),
    );
  }

  _customAppBar() => AppBar(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            Text(
              "LogOut",
              style: AppTextStyles.dynamicStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
    ],
  );
}

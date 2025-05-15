import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:security_wave/model/user_model.dart';
import 'package:security_wave/presentation/widgets/w_profile_tile.dart';
import 'package:security_wave/presentation/widgets/w_user_item_tile.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../provider/auth_provider.dart';
import '../dialogs/w_download_image_dialog.dart';
import '../dialogs/w_edit_bottom_sheet.dart';
import '../widgets/w_database_button.dart';

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
      backgroundColor: Colors.white,
      body: authState.when(
        data: (user) {
          if (user == null) return const Text("Not logged in");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileTile(user: user),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
                child: Text(
                  "Users List:",
                  style: AppTextStyles.dynamicStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              allUsers.when(
                data: (users) {
                  final currentUserEmail = user.email.toLowerCase();
                  final filteredUsers =
                      users
                          .where(
                            (u) => u.email.toLowerCase() != currentUserEmail,
                          )
                          .toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final u = filteredUsers[index];
                      return UserItemTile(user: u);
                    },
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                error: (e, _) => Text("Error: $e"),
              ),
            ],
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
        error: (e, _) => Text("Error: $e"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFetchDatabaseButton(context),
    );
  }
}

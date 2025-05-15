import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:security_wave/model/user_model.dart';
import 'package:security_wave/presentation/widgets/w_users_box.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../provider/auth_provider.dart';
import '../dialogs/w_edit_bottom_sheet.dart';

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
              Container(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: CachedNetworkImage(
                              imageUrl: user.profileImageUrl,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
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
                        onPressed:
                            () => ref.read(authRepositoryProvider).signOut(),
                        icon: Icon(Icons.logout, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: IconButton(
                        onPressed:
                            () => editProfileBottomSheet(context, ref, user),
                        icon: Icon(Icons.menu, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
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
                      return UserBox(user: u);
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
    );
  }
}

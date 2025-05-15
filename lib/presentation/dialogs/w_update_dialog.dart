import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

void showUpdateProfileDialog(
  BuildContext context, {
  required String uid,
  required String initialEmail,
  required String profileImageUrl,
  required void Function(String email, String imageUrl) onUpdate,
}) {
  final emailController = TextEditingController(text: initialEmail);
  String imageUrl = profileImageUrl;

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    final fileName = path.basename(pickedFile.path);

    final ref = FirebaseStorage.instance.ref().child(
      'profile_images/$uid/$fileName',
    );
    final downloadUrl = await ref.getDownloadURL();
    imageUrl = downloadUrl;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Update Profile',
              style: AppTextStyles.dynamicStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await pickAndUploadImage();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(imageUrl),
                      child:
                          imageUrl.isEmpty
                              ? Icon(Icons.camera_alt, size: 35)
                              : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: AppTextStyles.dynamicStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.dynamicStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onUpdate(emailController.text.trim(), imageUrl);
                },
                child: Text(
                  'Update',
                  style: AppTextStyles.dynamicStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

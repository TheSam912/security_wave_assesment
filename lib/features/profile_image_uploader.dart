import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class ProfileImageUploader extends StatefulWidget {
  final String uid;

  const ProfileImageUploader({required this.uid});

  @override
  State<ProfileImageUploader> createState() => _ProfileImageUploaderState();
}

class _ProfileImageUploaderState extends State<ProfileImageUploader> {
  File? _imageFile;
  final picker = ImagePicker();
  bool _uploading = false;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
    });

    await uploadToFirebase();
  }

  Future<void> uploadToFirebase() async {
    if (_imageFile == null) return;
    setState(() {
      _uploading = true;
    });

    try {
      String fileName = path.basename(_imageFile!.path);
      final ref = FirebaseStorage.instance.ref().child(
        'profile_images/${widget.uid}/$fileName',
      );

      await ref.putFile(_imageFile!);

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({'profileImageUrl': imageUrl});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile image uploaded successfully!')),
      );
    } catch (e) {
      print('Upload failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload image.')));
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _uploading
            ? CircularProgressIndicator()
            : _imageFile != null
            ? Image.file(_imageFile!, height: 150)
            : Placeholder(fallbackHeight: 150),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.camera),
              label: Text('Camera'),
              onPressed: () => pickImage(ImageSource.camera),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.photo),
              label: Text('Gallery'),
              onPressed: () => pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }
}

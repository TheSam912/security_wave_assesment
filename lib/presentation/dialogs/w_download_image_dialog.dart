import 'package:flutter/material.dart';

import '../../features/image_downloader.dart';

void downloadImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text("Save Image"),
        content: Text("Are you sure you want to save the image?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              saveImage(context, imageUrl);
            },
            child: Text("YES"),
          ),
        ],
      );
    },
  );
}

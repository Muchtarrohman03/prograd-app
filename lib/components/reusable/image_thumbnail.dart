import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/image_preview_page.dart';

class ImageThumbnail extends StatelessWidget {
  final File file;
  final String heroTag;
  final double height;

  const ImageThumbnail({
    super.key,
    required this.file,
    required this.heroTag,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) =>
                ImagePreviewPage(file: file, heroTag: heroTag),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Hero(
          tag: heroTag,
          child: Image.file(
            file,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover, // thumbnail boleh crop
          ),
        ),
      ),
    );
  }
}

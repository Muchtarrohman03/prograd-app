import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final File file;
  final String heroTag;

  const ImagePreviewPage({
    super.key,
    required this.file,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            /// IMAGE + ZOOM
            Center(
              child: Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  panEnabled: true,
                  child: Image.file(
                    file,
                    fit: BoxFit.contain, // FULL IMAGE, NO CROP
                  ),
                ),
              ),
            ),

            /// CLOSE BUTTON
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

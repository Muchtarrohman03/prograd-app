import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final File? file;
  final String? imageUrl;
  final String heroTag;

  const ImagePreviewPage({
    super.key,
    this.file,
    this.imageUrl,
    required this.heroTag,
  });

  bool get _isNetwork => imageUrl != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  child: _isNetwork
                      ? Image.network(imageUrl!, fit: BoxFit.contain)
                      : Image.file(file!, fit: BoxFit.contain),
                ),
              ),
            ),

            /// CLOSE BUTTON
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

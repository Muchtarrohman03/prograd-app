import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:laravel_flutter/components/reusable/image_preview_page.dart';

class ImageThumbnail extends StatelessWidget {
  final File? file;
  final String? imageUrl;
  final String heroTag;
  final double height;
  final VoidCallback? onRemove;

  const ImageThumbnail({
    super.key,
    this.file,
    this.imageUrl,
    required this.heroTag,
    this.height = 200,
    this.onRemove,
  }) : assert(
         file != null || imageUrl != null,
         'Either file or imageUrl must be provided',
       );

  bool get _isNetwork => imageUrl != null;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// IMAGE + HERO
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) => ImagePreviewPage(
                  file: file,
                  imageUrl: imageUrl,
                  heroTag: heroTag,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Hero(
              tag: heroTag,
              child: _isNetwork
                  ? Image.network(
                      imageUrl!,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          height: height,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => _errorBox(),
                    )
                  : Image.file(
                      file!,
                      height: height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),

        /// ❌ REMOVE BUTTON (OPSIONAL)
        if (onRemove != null)
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54.withAlpha(70),
                  shape: BoxShape.circle,
                ),
                child: const HeroIcon(
                  HeroIcons.trash,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _errorBox() {
    return Container(
      height: height,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BeforeAfterImagePicker extends StatelessWidget {
  final File? beforeImage;
  final File? afterImage;
  final Function(File file) onBeforePicked;
  final Function(File file) onAfterPicked;

  const BeforeAfterImagePicker({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    required this.onBeforePicked,
    required this.onAfterPicked,
  });

  Future<void> _pickImage({
    required BuildContext context,
    required Function(File) onPicked,
  }) async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image != null) {
      onPicked(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ImageBox(
            label: 'Before',
            image: beforeImage,
            onTap: () => _pickImage(context: context, onPicked: onBeforePicked),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ImageBox(
            label: 'After',
            image: afterImage,
            onTap: () => _pickImage(context: context, onPicked: onAfterPicked),
          ),
        ),
      ],
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String label;
  final File? image;
  final VoidCallback onTap;

  const _ImageBox({
    required this.label,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: image == null
              ? _Placeholder(label: label)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String label;

  const _Placeholder({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 32, color: Colors.grey.shade500),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

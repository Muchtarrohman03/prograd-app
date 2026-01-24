import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:dotted_border/dotted_border.dart';

class CustomImagePicker extends StatelessWidget {
  final VoidCallback captureAction;
  final double? height;
  final double? iconWidth;

  const CustomImagePicker({
    super.key,
    required this.captureAction,
    this.height,
    this.iconWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: captureAction,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(15),
          color: Colors.grey,
          strokeWidth: 1.5,
          dashPattern: const [5, 3],
          padding: const EdgeInsets.all(1),
        ),
        child: Container(
          width: double.infinity,
          height: height ?? 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(HeroIcons.camera, color: Colors.grey, size: iconWidth),
              const SizedBox(height: 5),
              Text(
                'Ambil Gambar',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: (iconWidth ?? 20) / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

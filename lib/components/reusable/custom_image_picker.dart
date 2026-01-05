import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:dotted_border/dotted_border.dart';

class CustomImagePicker extends StatelessWidget {
  final VoidCallback captureAction;

  const CustomImagePicker({super.key, required this.captureAction});

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
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              HeroIcon(HeroIcons.camera, color: Colors.grey, size: 40),
              SizedBox(height: 5),
              Text(
                'Ambil Gambar',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

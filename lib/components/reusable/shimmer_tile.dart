import 'package:flutter/material.dart';
import 'package:laravel_flutter/components/reusable/shimmer_text.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTile extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;
  final bool? showSubtitle;
  const ShimmerTile({
    super.key,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Shimmer.fromColors(
          baseColor: baseColor!,
          highlightColor: highlightColor!,
          child: CircleAvatar(
            radius: 24,
            child: Icon(Icons.image, color: Colors.white, size: 24),
          ),
        ),
        title: Shimmer.fromColors(
          baseColor: baseColor!,
          highlightColor: highlightColor!,
          child: ShimmerText(width: 150, height: 18),
        ),
        subtitle: showSubtitle!
            ? Shimmer.fromColors(
                baseColor: baseColor!,
                highlightColor: highlightColor!,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ShimmerText(width: 100, height: 14),
                ),
              )
            : null,
        trailing: Shimmer.fromColors(
          baseColor: baseColor!,
          highlightColor: highlightColor!,
          child: CircleAvatar(
            radius: 14,
            child: ShimmerText(width: 10, height: 10),
          ),
        ),
      ),
    );
  }
}

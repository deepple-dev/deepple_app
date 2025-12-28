import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:deepple_app/features/profile/presentation/widget/widget.dart';

class SkeletonProfile extends StatelessWidget {
  const SkeletonProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 10.0,
          children: [
            ProfileAppbar(),
            _RoundedSkeleton(height: 400.0),
            _RoundedSkeleton(height: 180.0),
          ],
        ),
      ),
    );
  }
}

class _RoundedSkeleton extends StatelessWidget {
  const _RoundedSkeleton({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.grey,
        ),
        margin: const EdgeInsets.all(16.0),
        height: height,
      ),
    );
  }
}

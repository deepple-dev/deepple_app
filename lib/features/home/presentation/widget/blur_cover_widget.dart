import 'dart:ui';

import 'package:flutter/material.dart';

class BlurCoverWidget extends StatelessWidget {
  final bool isRect;
  const BlurCoverWidget({super.key, required this.isRect});

  @override
  Widget build(BuildContext context) {
    final filter = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
      ),
    );

    return Positioned.fill(
      child: isRect ? ClipRect(child: filter) : ClipOval(child: filter),
    );
  }
}

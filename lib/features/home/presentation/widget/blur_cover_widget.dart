import 'dart:ui';

import 'package:flutter/material.dart';

class BlurCoverWidget extends StatelessWidget {
  const BlurCoverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999)),
          ),
        ),
      ),
    );
  }
}

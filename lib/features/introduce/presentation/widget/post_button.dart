import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';

class PostButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PostButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.h,
      right: 20.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Palette.colorPrimary500,
            shape: BoxShape.circle,
          ),
          child: const DefaultIcon(IconPath.post, size: 24),
        ),
      ),
    );
  }
}

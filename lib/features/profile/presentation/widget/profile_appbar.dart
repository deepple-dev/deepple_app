import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key, this.onBackButtonPressed, this.onTapInfo})
    : matched = false;

  const ProfileAppbar.matched({
    super.key,
    this.onBackButtonPressed,
    this.onTapInfo,
  }) : matched = true;

  final bool matched;
  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onTapInfo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: matched ? Text('매칭 확인', style: Fonts.body01Medium()) : null,
      centerTitle: true,
      leading: GestureDetector(
        onTap: onBackButtonPressed ?? context.pop,
        child: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        IconButton(
          onPressed: onTapInfo,
          icon: const Icon(Icons.info_outline, size: 24.0),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

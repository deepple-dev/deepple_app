import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/constants/fonts.dart';

class BulletText extends StatelessWidget {
  final String text;

  const BulletText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: Fonts.body03Regular(Palette.colorGrey800)),
          Expanded(
            child: Text(text, style: Fonts.body03Regular(Palette.colorGrey800)),
          ),
        ],
      ),
    );
  }
}

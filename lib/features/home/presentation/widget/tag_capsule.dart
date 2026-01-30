import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter/material.dart';

class TagCapsules extends StatelessWidget {
  final double capsuleVerticalPadding = 2.0;
  final double capsuleHorizontalPadding = 6.0;
  final double spacing = 6.0; // capsule 간격

  final List<String> hobbies;
  const TagCapsules({super.key, required this.hobbies});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        double capsulesWidth = 0; // 전체 길이
        final List<Widget> capsuled = [];
        int hiddenCount = 0; // 가려진 위젯

        for (int i = 0; i < hobbies.length; i++) {
          final hobby = hobbies[i];

          final textPainter = TextPainter(
            text: TextSpan(text: hobby, style: Fonts.medium(fontSize: 12.0)),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();

          // 캡슐 너비
          final capsuleWidth =
              textPainter.width.ceil() + capsuleHorizontalPadding * 2 + spacing;

          if (capsulesWidth + capsuleWidth < maxWidth) {
            capsulesWidth += capsuleWidth;
            capsuled.add(
              _TagCapsule(
                name: hobby,
                horizontalPadding: capsuleHorizontalPadding,
                verticalPadding: capsuleVerticalPadding,
              ),
            );
          } else {
            hiddenCount = hobbies.length - i;
            break;
          }
        }

        if (hiddenCount > 0) {
          capsuled.add(
            _TagCapsule(
              name: '+$hiddenCount',
              horizontalPadding: capsuleHorizontalPadding,
              verticalPadding: capsuleVerticalPadding,
            ),
          );
        }

        return Row(spacing: spacing, children: capsuled);
      },
    );
  }
}

class _TagCapsule extends StatelessWidget {
  final String name;
  final double verticalPadding;
  final double horizontalPadding;

  const _TagCapsule({
    required this.name,
    required this.verticalPadding,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.colorPrimary500,
        borderRadius: BorderRadius.circular(100.0),
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Text(
        name,
        style: Fonts.medium(fontSize: 12.0, color: Palette.colorWhite),
      ),
    );
  }
}

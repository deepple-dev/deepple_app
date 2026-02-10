import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        final tagList = checkTagList(context, constraints);

        return Row(
          spacing: spacing,
          children: tagList
              .map(
                (tag) => _TagCapsule(
                  name: tag,
                  horizontalPadding: capsuleHorizontalPadding,
                  verticalPadding: capsuleVerticalPadding,
                ),
              )
              .toList(),
        );
      },
    );
  }

  TextPainter _makeTextPainter(String text) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: Fonts.medium(fontSize: 12.0.sp),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
  }

  List<String> checkTagList(BuildContext context, BoxConstraints constraints) {
    final maxWidth = constraints.maxWidth;

    double sumWidth = 0; // 전체 길이
    final List<String> tagList = [];
    int hiddenCount = 0; // 가려진 위젯

    for (int i = 0; i < hobbies.length; i++) {
      final hobby = hobbies[i];

      final textPainter = _makeTextPainter(hobby);

      // 캡슐 너비
      final capsuleWidth =
          textPainter.width.ceil() + capsuleHorizontalPadding * 2 + spacing;

      if (sumWidth + capsuleWidth < maxWidth) {
        sumWidth += capsuleWidth;
        tagList.add(hobby);
      } else {
        hiddenCount = hobbies.length - i;
        break;
      }
    }

    if (hiddenCount > 0) {
      // hidden 캡슐의 길이 계산
      final textPainter = _makeTextPainter('+$hiddenCount');

      final capsuleWidth =
          textPainter.width.ceil() + capsuleHorizontalPadding * 2 + spacing;

      // 히든 캡슐 over 시 기존에 있던 캡슐 삭제 후 히든 캡슐 추가
      if (sumWidth + capsuleWidth > maxWidth) {
        hiddenCount += 1;
        tagList.removeLast();
      }
      tagList.add('+$hiddenCount');
    }

    return tagList;
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
        style: Fonts.medium(fontSize: 12.0.sp, color: Palette.colorWhite),
      ),
    );
  }
}

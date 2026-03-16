import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BulletText extends StatelessWidget {
  final List<String> texts;
  final Color bulletColor;
  final TextStyle textStyle;
  final double bulletSize;
  final double spacing;
  final double bottomPadding;

  const BulletText({
    super.key,
    required this.texts,
    this.bulletColor = Colors.grey,
    this.bulletSize = 20.0,
    required this.textStyle,
    this.spacing = 4.0,
    this.bottomPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts.map((text) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: text != texts.last ? bottomPadding : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Baseline(
                baseline: textStyle.fontSize!, // 불릿의 베이스라인 조정
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  '•', // 불릿
                  style: TextStyle(fontSize: bulletSize, color: bulletColor),
                ),
              ),
              Gap(spacing), // 불릿과 텍스트 간 간격
              Expanded(
                child: Text(
                  text, // 동적으로 전달된 텍스트
                  style: textStyle,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

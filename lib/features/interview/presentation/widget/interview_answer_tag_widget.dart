import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';

class InterviewAnswerTagWidget extends StatelessWidget {
  const InterviewAnswerTagWidget(this.isAnswered, {super.key});
  final bool isAnswered;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isAnswered ? context.palette.primary : Palette.colorGrey100,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        isAnswered ? '답변 완료 🎉' : '미답변',
        style: Fonts.body03Regular(
          isAnswered ? context.palette.onPrimary : Palette.colorGrey800,
        ),
      ),
    );
  }
}

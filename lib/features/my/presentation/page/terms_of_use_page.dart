import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/constants/terms_of_use.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '이용약관'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: Fonts.body02Medium().copyWith(
                color: Palette.colorGrey500,
                fontWeight: FontWeight.w400,
              ),
              children: _parseTermsOfuse(termsOfUseText),
            ),
          ),
        ),
      ),
    );
  }
}

List<TextSpan> _parseTermsOfuse(String text) =>
    text.split('\n').map((lineContent) {
      if (lineContent.contains('총칙')) {
        return TextSpan(
          text: '${lineContent.replaceAll("*", "")}\n',
          style: Fonts.body02Medium().copyWith(
            color: Palette.colorGrey800,
            fontWeight: FontWeight.w600,
          ),
        );
      } else if (lineContent.contains('*')) {
        return TextSpan(
          text: '${lineContent.replaceAll("*", "")}\n',
          style: Fonts.body02Medium().copyWith(
            color: Palette.colorGrey800,
            fontWeight: FontWeight.w400,
          ),
        );
      }
      return TextSpan(text: '$lineContent\n');
    }).toList();

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/constants/privacy_policy.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '개인정보 취급방침'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: Fonts.body02Medium().copyWith(
                color: Palette.colorGrey500,
                fontWeight: FontWeight.w400,
              ),
              children: _parsePrivacyPolicy(privacyPolicyText),
            ),
          ),
        ),
      ),
    );
  }
}

List<TextSpan> _parsePrivacyPolicy(String text) =>
    text.split('\n').map((lineContent) {
      if (lineContent.startsWith('### ')) {
        return TextSpan(
          text: '${lineContent.substring(4)}\n',
          style: Fonts.body02Medium().copyWith(
            color: Palette.colorGrey800,
            fontWeight: FontWeight.w600,
          ),
        );
      }
      return TextSpan(text: '$lineContent\n');
    }).toList();

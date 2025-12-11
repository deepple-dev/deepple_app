import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/constants/community_guide.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:flutter/material.dart';

class CommunityGuidePage extends StatelessWidget {
  const CommunityGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '커뮤니티 가이드'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: Fonts.body02Medium().copyWith(
                color: Palette.colorGrey500,
                fontWeight: FontWeight.w400,
              ),
              children: _parseCommunityGuide(communityGuideText),
            ),
          ),
        ),
      ),
    );
  }
}

List<TextSpan> _parseCommunityGuide(String text) =>
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

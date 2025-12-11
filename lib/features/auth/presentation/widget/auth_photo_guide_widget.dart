import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AuthPhotoGuideWidget extends StatelessWidget {
  final String title;
  final List<Map<String, String>> imagePathsWithText;

  const AuthPhotoGuideWidget({
    super.key,
    required this.title,
    required this.imagePathsWithText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Fonts.header03().copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: imagePathsWithText.length,
          itemBuilder: (context, index) {
            final imagePath = imagePathsWithText[index]['image']!;
            final imageText = imagePathsWithText[index]['text']!;
            return Stack(
              children: [
                // 이미지
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 텍스트가 포함된 반투명한 배경
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40, // 텍스트 컨테이너 높이
                    decoration: BoxDecoration(
                      color: Palette.colorBlack.withAlpha(180),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        imageText,
                        style: Fonts.body03Regular(Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

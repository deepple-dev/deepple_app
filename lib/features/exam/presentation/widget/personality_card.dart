import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/image/default_image.dart';
import 'package:deepple_app/features/exam/domain/model/personality_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalityCard extends StatelessWidget {
  final PersonalityType type;

  const PersonalityCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final content = type.content;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(content.cardBgColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 273.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Color(content.imageBgColor),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Center(
              child: DefaultImage.asset(
                content.imageUrl,
                width: double.infinity,
                height: 273.h,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: const TextStyle(
                    color: Palette.colorWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.description,
                  style: TextStyle(
                    color: Palette.colorWhite,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: content.tags
                      .map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: Color(content.tagColor),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

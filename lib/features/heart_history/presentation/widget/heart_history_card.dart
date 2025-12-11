import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter/material.dart';

class HeartHistoryCard extends StatelessWidget {
  final DateTime createdAt;
  final String content;
  final int heartAmount;

  const HeartHistoryCard({
    super.key,
    required this.createdAt,
    required this.content,
    required this.heartAmount,
  });

  String get _displayedDate {
    final dateData = createdAt.toLocal(); // 필요시 toLocal()
    final year = dateData.year % 100; // 2025 → 25
    final month = dateData.month.toString().padLeft(2, '0'); // 6 → 06
    final day = dateData.day.toString().padLeft(2, '0'); // 10 → 10
    return '$year.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                _displayedDate,
                style: Fonts.body02Regular(Palette.colorGrey500),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                content,
                style: Fonts.body01Medium(Palette.colorBlack),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '$heartAmount',
                textAlign: TextAlign.right,
                style: Fonts.body01Medium(
                  heartAmount.sign < 0
                      ? Palette.colorSecondary500
                      : Palette.colorPrimary500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

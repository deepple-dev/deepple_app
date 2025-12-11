import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:gap/gap.dart';

class AnswerRadioButton extends StatelessWidget {
  final int id;
  final int? selectedId;
  final String content;
  final Function(int) onTap;

  const AnswerRadioButton({
    super.key,
    required this.id,
    required this.selectedId,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(id),
      style:
          ElevatedButton.styleFrom(
            backgroundColor: selectedId == id
                ? Palette.colorPrimary100
                : Palette.colorWhite,
            foregroundColor: Palette.colorBlack,
            side: const BorderSide(color: Palette.colorGrey100, width: 1.0),
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            textStyle: Fonts.body01Medium(),
            minimumSize: const Size(double.infinity, 0),
            alignment: Alignment.centerLeft,
          ).copyWith(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            elevation: WidgetStateProperty.all(0),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: selectedId == id
                  ? Border.all(color: Palette.colorPrimary500, width: 4.5)
                  : Border.all(color: Palette.colorGrey200, width: 1.5),
            ),
          ),
          const Gap(8),
          Flexible(
            child: Text(
              content,
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: null,
              textAlign: TextAlign.start,
              style: Fonts.body02Regular(Palette.colorBlack),
            ),
          ),
        ],
      ),
    );
  }
}

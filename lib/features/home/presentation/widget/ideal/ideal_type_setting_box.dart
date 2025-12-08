import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/features/home/domain/model/ideal_type.dart';
import 'package:deepple_app/features/home/presentation/provider/provider.dart';
import 'package:deepple_app/features/home/presentation/widget/ideal/ideal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class IdealTypeSettingBox extends ConsumerWidget {
  const IdealTypeSettingBox({
    super.key,
    required this.item,
    required this.idealType,
  });

  final IdealTypeSettingItem item;
  final IdealType? idealType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: Fonts.body02Regular().copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const Gap(8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _showDialog(context, ref),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Palette.colorGrey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.placeholder,
              style: Fonts.body02Regular().copyWith(
                fontWeight: FontWeight.w400,
                color: Palette.colorBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, WidgetRef ref) {
    final options = item.options;
    final label = item.label;
    final notifier = ref.read(idealTypeProvider.notifier);

    switch (item.type) {
      case IdealTypeDialogType.single:
        int initialIndex = switch (label) {
          '흡연' => options.indexOf(item.placeholder),
          '음주' => options.indexOf(item.placeholder),
          '종교' => options.indexOf(item.placeholder),
          _ => 0,
        };

        showDialog(
          context: context,
          builder: (_) => SingleBtnSelectDialg(
            label: label,
            options: options,
            initialIndex: initialIndex >= 0 ? initialIndex : 0,
            onItemSelected: (selectedValue) {
              switch (item.label) {
                case '흡연':
                  notifier.updateSmokingStatus(selectedValue);
                  break;
                case '음주':
                  notifier.updateDrinkingStatus(selectedValue);
                  break;
                case '종교':
                  notifier.updateReligion(selectedValue);
                  break;
              }
            },
          ),
        );
        break;

      case IdealTypeDialogType.multi:
        List<String> selectedValues = switch (label) {
          '지역' => idealType?.cities.map((e) => e.label).toList() ?? [],
          '취미' => idealType?.hobbies.map((e) => e.label).toList() ?? [],
          _ => [],
        };
        showDialog(
          context: context,
          builder: (_) => MultiBtnSelectDialog(
            title: label,
            btnNames: options,
            maxSelectableCount: item.maxSelectableCount,
            selectedValues: selectedValues,
            onSubmit: (selectedItems) {
              switch (label) {
                case '지역':
                  notifier.updateCities(selectedItems);
                  break;
                case '취미':
                  notifier.updateHobbies(selectedItems);
                  break;
              }
              context.pop();
            },
          ),
        );
        break;
    }
  }
}

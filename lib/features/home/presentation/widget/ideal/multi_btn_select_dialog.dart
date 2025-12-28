import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MultiBtnSelectDialog extends StatefulWidget {
  const MultiBtnSelectDialog({
    super.key,
    required this.btnNames,
    required this.maxSelectableCount,
    required this.title,
    required this.selectedValues,
    required this.onSubmit,
  });

  final String title; // 다이얼로그 제목
  final List<String> btnNames; // 선택된 버튼 이름 리스트
  final int maxSelectableCount; // 최대 선택 가능 개수
  final List<String> selectedValues;
  final void Function(List<String> selectedItems) onSubmit;

  @override
  State<MultiBtnSelectDialog> createState() => _MultiBtnSelectDialogState();
}

class _MultiBtnSelectDialogState extends State<MultiBtnSelectDialog> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: context.screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: context.pop,
                      child: const DefaultIcon(IconPath.close),
                    ),
                  ],
                ),
                Column(
                  spacing: 20,
                  children: [
                    Column(
                      spacing: 14,
                      children: [
                        Text(
                          widget.title,
                          style: Fonts.semibold(
                            fontSize: 18,
                            color: Palette.colorBlack,
                          ),
                        ),
                        Text(
                          '최대 ${widget.maxSelectableCount}개까지 선택이 가능해요',
                          style: Fonts.body02Regular().copyWith(
                            color: Palette.colorGrey500,
                          ),
                        ),
                        SizedBox(
                          height: context.screenHeight * 0.26,
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8.0, // 가로 간격
                              runSpacing: 8.0, // 세로 간격
                              children: widget.btnNames.map((tag) {
                                bool isSelected = _selectedItems.contains(tag);
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _toggleItem(tag),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Palette.colorPrimary100
                                          : Colors.white,
                                      border: Border.all(
                                        color: isSelected
                                            ? Palette.colorPrimary100
                                            : Palette.colorGrey200,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: Fonts.body02Regular(
                                        isSelected
                                            ? Palette.colorPrimary600
                                            : Palette.colorGrey800,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    DefaultElevatedButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onPressed: () => widget.onSubmit(_selectedItems),
                      onPrimary: context.palette.onPrimary,
                      primary: context.palette.primary,
                      child: const Text('확인'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        // 이미 선택된 아이템이면 제거
        _selectedItems.remove(item);
      } else {
        // 선택되지 않은 아이템이고 최대 선택 개수를 초과하지 않으면 추가
        if (_selectedItems.length < widget.maxSelectableCount) {
          _selectedItems.add(item);
        }
      }
    });
  }
}

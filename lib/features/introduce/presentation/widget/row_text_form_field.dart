import 'package:deepple_app/app/constants/region_data.dart';
import 'package:deepple_app/features/home/presentation/widget/ideal/multi_btn_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:go_router/go_router.dart';

class RowTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> initialValues;
  final TextStyle? textStyle;
  final void Function(List<String>) onSubmit;

  const RowTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.initialValues,
    this.textStyle,
    required this.onSubmit,
  });

  @override
  State<RowTextFormField> createState() => _RowTextFormFieldState();
}

class _RowTextFormFieldState extends State<RowTextFormField> {
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedValues = widget.initialValues;
    return buildLabeledRow(
      textStyle: widget.textStyle,
      context: context,
      label: widget.label,
      child: Row(
        children: [
          Expanded(
            child: _showDialog(),
          ),
        ],
      ),
    );
  }

  Widget _showDialog() {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => MultiBtnSelectDialog(
          btnNames: addressData.cities.map((e) => e.label).toList(),
          maxSelectableCount: 2,
          title: '선호 지역',
          selectedValues: selectedValues,
          onSubmit: (selectedItems) {
            widget.onSubmit(selectedItems);
            context.pop();
          },
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Palette.colorGrey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          selectedValues.isEmpty ? widget.hintText : selectedValues.join(", "),
          style: Fonts.body02Regular(
            selectedValues.isEmpty ? Palette.colorGrey500 : Palette.colorBlack,
          ),
        ),
      ),
    );
  }
}

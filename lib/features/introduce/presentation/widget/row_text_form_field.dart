import 'package:flutter/material.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/features/introduce/presentation/widget/region_select_dialog.dart';
import 'package:deepple_app/app/constants/constants.dart';

class RowTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final TextStyle? textStyle;
  final List<String> selectedCityList;
  final void Function(List<String>) onSelectedCity;

  const RowTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.initialValue,
    this.textStyle,
    required this.selectedCityList,
    required this.onSelectedCity,
  });

  @override
  State<RowTextFormField> createState() => _RowTextFormFieldState();
}

class _RowTextFormFieldState extends State<RowTextFormField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = widget.initialValue;
    return buildLabeledRow(
      textStyle: widget.textStyle,
      context: context,
      label: widget.label,
      child: DefaultTextFormField(
        initialValue: widget.initialValue,
        controller: controller,
        onTap: () async {
          final selectedCities = await RegionSelectDialog.open(
            context,
            widget.selectedCityList,
          );
          widget.onSelectedCity(selectedCities ?? []);
        },
        enabled: true,
        readOnly: true,
        autofocus: false,
        keyboardType: TextInputType.text,
        hintText: widget.hintText,
        fillColor: Palette.colorGrey100,
      ),
    );
  }
}

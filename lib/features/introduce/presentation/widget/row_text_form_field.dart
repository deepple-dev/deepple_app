import 'package:flutter/material.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/features/introduce/presentation/widget/region_select_dialog.dart';
import 'package:deepple_app/app/constants/constants.dart';

class RowTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextStyle? textStyle;
  final List<String> selectedCityList;
  final void Function(List<String>) onSelectedCity;

  const RowTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.textStyle,
    required this.selectedCityList,
    required this.onSelectedCity,
  });

  @override
  State<RowTextFormField> createState() => _RowTextFormFieldState();
}

class _RowTextFormFieldState extends State<RowTextFormField> {
  late TextEditingController controller;
  late List<String>? _selectedCities;

  @override
  void initState() {
    _selectedCities = widget.selectedCityList;

    controller = TextEditingController();
    controller.text = _selectedCities?.join(', ') ?? '';
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildLabeledRow(
      textStyle: widget.textStyle,
      context: context,
      label: widget.label,
      child: DefaultTextFormField(
        initialValue: controller.text,
        controller: controller,
        onTap: () async {
          _selectedCities = await RegionSelectDialog.open(
            context,
            widget.selectedCityList,
          );

          controller.text = _selectedCities?.join(', ') ?? '';
          widget.onSelectedCity(_selectedCities ?? []);
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

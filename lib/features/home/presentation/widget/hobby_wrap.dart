import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter/material.dart';

class HobbyWrap extends StatelessWidget {
  final List<String> hobbies;
  const HobbyWrap({super.key, required this.hobbies});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: hobbies.map((hobby) => _HobbyCapsule(name: hobby)).toList(),
    );
  }
}

class _HobbyCapsule extends StatelessWidget {
  final String name;

  const _HobbyCapsule({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.colorPrimary500,
        borderRadius: BorderRadius.circular(100.0),
      ),

      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      child: Text(
        name,
        style: Fonts.medium(fontSize: 12.0, color: Palette.colorWhite),
      ),
    );
  }
}

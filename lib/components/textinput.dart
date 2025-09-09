// File: mfar_superapp/lib/components/textinput.dart
import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText, hintText: hintText, border: const OutlineInputBorder()),
    );
  }
}

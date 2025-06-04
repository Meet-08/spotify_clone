import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      validator: (value) {
        if (value!.trim().isEmpty) return "$hintText cannot be empty";
        return null;
      },
      obscureText: isObscure,
    );
  }
}

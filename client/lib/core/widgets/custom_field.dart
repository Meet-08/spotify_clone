import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomField({
    super.key,
    required this.hintText,
    this.controller,
    this.isObscure = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
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

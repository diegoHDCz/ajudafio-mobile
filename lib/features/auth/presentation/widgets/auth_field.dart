import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  const AuthField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(hintText: hintText),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "$hintText is required";
            }
            return null;
          },
    );
  }
}

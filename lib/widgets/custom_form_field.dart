import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String labelText;
  final double height;
  final RegExp validationRegEx;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.height,
    required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value) {
          if (value != null && validationRegEx.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${labelText.toLowerCase()}";
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: labelText,
          hintText: "Type your $labelText",
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    required this.labelText,
    required this.obscureText,
    required this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.autofillHints,
  });
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).primaryColor),
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withAlpha(100), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      autofillHints: autofillHints,
    );
  }
}

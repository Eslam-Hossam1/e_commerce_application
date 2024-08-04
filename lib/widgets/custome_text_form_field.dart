import 'package:flutter/material.dart';

class CustomeTextFormField extends StatelessWidget {
  const CustomeTextFormField({
    super.key,
    required this.hintText,
    this.onSaved,
  });
  final String hintText;
  final void Function(String?)? onSaved;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: (value) {
        if (value == '' || value == null) {
          return "this field required";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderSide: BorderSide())),
    );
  }
}

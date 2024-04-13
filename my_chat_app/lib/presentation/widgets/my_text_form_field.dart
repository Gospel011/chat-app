
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
      required TextEditingController controller,
      this.hintText,
      this.keyboardType,
      this.maxLines,
      this.minLines,
      this.inputFormatters,
      required this.validator})
      : _phoneController = controller;

  final String? Function(String?) validator;
  final String? hintText;
  final int? maxLines;
  final int? minLines;

  final TextEditingController _phoneController;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _phoneController,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600)),
        errorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}

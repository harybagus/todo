import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToDoTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final bool obsecureText;
  final bool readOnly;

  const ToDoTextFormField({
    super.key,
    required this.controller,
    this.inputFormatters,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.obsecureText,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      obscureText: obsecureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        prefixIcon: prefixIcon,
        prefixIconColor: Theme.of(context).colorScheme.inversePrimary,
        suffixIcon: suffixIcon,
        suffixIconColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ToDoTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final bool obsecureText;

  const ToDoTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.obsecureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecureText,
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

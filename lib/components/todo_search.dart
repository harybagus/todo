import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoSearch extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final String text;

  const ToDoSearch({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, size: 23),
          hintText: text,
          hintStyle: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}

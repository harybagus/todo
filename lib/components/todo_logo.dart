import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoLogo extends StatelessWidget {
  final double fontSize;

  const ToDoLogo({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'to',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        Text(
          'do.',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

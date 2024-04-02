import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const ToDoButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        fixedSize: Size(MediaQuery.sizeOf(context).width, 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SnackBar toDoSnackBar(Color color, String text) {
  return SnackBar(
    backgroundColor: color,
    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: Text(
      text,
      style: GoogleFonts.poppins(fontSize: 17, color: Colors.white),
    ),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    closeIconColor: Colors.white,
  );
}

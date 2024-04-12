import 'package:flutter/material.dart';

SnackBar toDoSnackBar(Color color, String text) {
  return SnackBar(
    backgroundColor: color,
    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: Text(
      text,
      style: const TextStyle(fontSize: 17),
    ),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
  );
}

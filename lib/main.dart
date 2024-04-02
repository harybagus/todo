import 'package:flutter/material.dart';
import 'package:todo/authentication/login_or_register.dart';
import 'package:todo/themes/dark_mode.dart';
import 'package:todo/themes/light_mode.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: lightMode,
    );
  }
}

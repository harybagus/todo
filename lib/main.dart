import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/authentication/login_or_register.dart';
import 'package:todo/themes/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider()..initialize(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

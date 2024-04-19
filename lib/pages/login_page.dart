import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_button.dart';
import 'package:todo/components/todo_logo.dart';
import 'package:todo/components/todo_snackbar.dart';
import 'package:todo/components/todo_textformfield.dart';
import 'package:todo/models/account.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/services/authentication_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // is visible
  bool isVisisble = true;

  final account = Account();
  final authenticationService = AuthenticationService();

  // login method
  login() async {
    String email = emailController.text;
    String password = passwordController.text;

    // if all is empty
    if (email.isEmpty && password.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Email dan password harus diisi',
      ));

      return;
    }

    // if one of them is empty
    if (email.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Email harus diisi',
      ));

      return;
    } else if (password.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Password harus diisi',
      ));

      return;
    }

    var existingAccount = await authenticationService.readAccountByEmail(email);

    dynamic accountPassword;
    dynamic accountId;

    existingAccount.forEach((account) {
      setState(() {
        accountPassword = account['password'];
        accountId = account['id'];
      });
    });

    // email not registered
    if (existingAccount.isEmpty) {
      if (mounted) {
        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Email belum terdaftar',
        ));
      }

      // delete text in controller
      emailController.clear();
      passwordController.clear();

      return;
    }

    // wrong password
    if (accountPassword != password) {
      if (mounted) {
        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Password salah',
        ));
      }

      passwordController.clear();

      return;
    }

    // login successfully
    if (existingAccount.isNotEmpty) {
      // delete text in controller
      emailController.clear();
      passwordController.clear();

      if (mounted) {
        // success message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.green,
          'Berhasil masuk',
        ));

        // navigate to home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(id: accountId)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                const ToDoLogo(fontSize: 50),

                const SizedBox(height: 20),

                // email textfield
                ToDoTextFormField(
                  controller: emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  obsecureText: false,
                  readOnly: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                ToDoTextFormField(
                  controller: passwordController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisisble = !isVisisble;
                      });
                    },
                    icon: Icon(isVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: isVisisble,
                  readOnly: false,
                ),

                const SizedBox(height: 20),

                // sign in button
                ToDoButton(
                  onPressed: login,
                  color: Theme.of(context).colorScheme.primary,
                  text: 'Masuk',
                ),

                const SizedBox(height: 20),

                // Don't have an account yet? sign up now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Daftar sekarang!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

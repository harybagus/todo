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

    // if all are empty
    if (email.isEmpty && password.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Email dan password harus diisi',
      ));

      return;
    }

    // if one of them are empty
    if (email.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Email harus diisi',
      ));

      return;
    } else if (password.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
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
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.red,
          20,
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
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.red,
          20,
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
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          20,
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
                const TodoLogo(fontSize: 50),

                const SizedBox(height: 20),

                // email textfield
                TodoTextFormField(
                  controller: emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

                // password textfield
                TodoTextFormField(
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
                  maxLines: 1,
                ),

                const SizedBox(height: 20),

                // sign in button
                TodoButton(
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

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_button.dart';
import 'package:todo/components/todo_snackbar.dart';
import 'package:todo/components/todo_textformfield.dart';
import 'package:todo/models/account.dart';
import 'package:todo/pages/login_page.dart';
import 'package:todo/services/authentication_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // is visible
  bool passwordIsVisisble = true;
  bool confirmPasswordIsVisisble = true;

  final account = Account();
  final authenticationService = AuthenticationService();

  // register method
  register() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // if all are empty
    if (name.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Nama, email, password dan konfirmasi password harus diisi',
      ));

      return;
    }

    // if one of them are empty
    if (name.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Nama harus diisi',
      ));

      return;
    } else if (email.isEmpty) {
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
    } else if (confirmPassword.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Konfirmasi password harus diisi',
      ));

      return;
    }

    // email validation
    if (!EmailValidator.validate(email)) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Email tidak valid',
      ));

      return;
    }

    // password less than 8 characters
    if (password.length < 8) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Password minimal harus 8 karakter',
      ));

      return;
    }

    // password and confirm password are not the same
    if (password != confirmPassword) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Password dan konfirmasi password tidak sama',
      ));

      // delete text in controller
      passwordController.clear();
      confirmPasswordController.clear();

      return;
    }

    var existingEmail = await authenticationService.readAccountByEmail(email);

    // email already exists
    if (existingEmail.isNotEmpty) {
      if (mounted) {
        // error message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.red,
          20,
          'Email sudah terdaftar',
        ));
      }

      // delete text in controller
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      return;
    }

    // account data
    account.name = name;
    account.email = email;
    account.password = password;
    account.imageName = 'null';

    // create account
    var createAccount = await authenticationService.createAccount(account);

    // create account successfully
    if (createAccount > 0) {
      // delete text in controller
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      if (mounted) {
        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          20,
          'Berhasil mendaftar, silakan masuk',
        ));

        // navigate to login page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
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
                // title
                Text(
                  'Daftar Akun',
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // name textfield
                TodoTextFormField(
                  controller: nameController,
                  hintText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline),
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

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
                        passwordIsVisisble = !passwordIsVisisble;
                      });
                    },
                    icon: Icon(passwordIsVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: passwordIsVisisble,
                  maxLines: 1,
                ),

                const SizedBox(height: 10),

                // password textfield
                TodoTextFormField(
                  controller: confirmPasswordController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Konfirmasi password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        confirmPasswordIsVisisble = !confirmPasswordIsVisisble;
                      });
                    },
                    icon: Icon(confirmPasswordIsVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: confirmPasswordIsVisisble,
                  maxLines: 1,
                ),

                const SizedBox(height: 20),

                // sign in button
                TodoButton(
                  onPressed: () => register(),
                  color: Theme.of(context).colorScheme.primary,
                  text: 'Daftar',
                ),

                const SizedBox(height: 20),

                // Already have an account? sign in now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Masuk sekarang!',
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

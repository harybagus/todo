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

    // if all is empty
    if (name.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Nama, email, password dan konfirmasi password harus diisi',
      ));

      return;
    }

    // is one of them is empty
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Nama harus diisi',
      ));

      return;
    } else if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Email harus diisi',
      ));

      return;
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Password harus diisi',
      ));

      return;
    } else if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Konfirmasi password harus diisi',
      ));

      return;
    }

    // password less than 8 characters
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Password minimal harus 8 karakter',
      ));

      return;
    }

    // password and confirm password are not the same
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
        Colors.red,
        'Password dan konfirmasi password tidak sama',
      ));

      passwordController.clear();
      confirmPasswordController.clear();

      return;
    }

    var existingEmail = await authenticationService.readAccountByEmail(email);

    if (existingEmail.isNotEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Email sudah terdaftar',
        ));
      }

      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      return;
    }

    account.name = name;
    account.email = email;
    account.password = password;
    account.photoName = 'default';

    var createAccount = await authenticationService.createAccount(account);

    if (createAccount > 0) {
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.green,
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
                  "Daftar Akun",
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 20),

                // name textfield
                ToDoTextFormField(
                  controller: nameController,
                  hintText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline),
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                ToDoTextFormField(
                  controller: emailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  obsecureText: false,
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
                        passwordIsVisisble = !passwordIsVisisble;
                      });
                    },
                    icon: Icon(passwordIsVisisble
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                  ),
                  obsecureText: passwordIsVisisble,
                ),

                const SizedBox(height: 10),

                // password textfield
                ToDoTextFormField(
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
                ),

                const SizedBox(height: 20),

                // sign in button
                ToDoButton(
                  onPressed: () => register(),
                  text: "Daftar",
                ),

                const SizedBox(height: 20),

                // Already have an account? sign in now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun?",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Masuk sekarang!",
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

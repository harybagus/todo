import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_button.dart';
import 'package:todo/components/todo_textfield.dart';

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
                ToDoTextField(
                  controller: nameController,
                  hintText: 'Nama',
                  prefixIcon: const Icon(Icons.person_outline),
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                ToDoTextField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  obsecureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                ToDoTextField(
                  controller: passwordController,
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
                ToDoTextField(
                  controller: confirmPasswordController,
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
                ToDoButton(onPressed: () {}, text: "Daftar"),

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

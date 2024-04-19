import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_button.dart';
import 'package:todo/components/todo_image.dart';
import 'package:todo/components/todo_snackbar.dart';
import 'package:todo/components/todo_textformfield.dart';
import 'package:todo/models/account.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/pages/login_page.dart';
import 'package:todo/services/authentication_service.dart';

class ProfilePage extends StatefulWidget {
  final int id;

  const ProfilePage({super.key, required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // text editing controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  // is visible
  bool currentPasswordIsVisisble = true;
  bool newPasswordIsVisisble = true;
  bool confirmNewPasswordIsVisisble = true;

  // is pressed
  bool changePasswordIsPressed = false;

  final account = Account();
  final authenticationService = AuthenticationService();

  // account
  String accountName = '';
  String accountEmail = '';
  String accountPassword = '';
  String accountImageName = '';

  // get account
  getAccount() async {
    // get account by id
    dynamic account = await authenticationService.readAccountById(widget.id);

    account.forEach((account) {
      setState(() {
        accountName = account['name'];
        accountEmail = account['email'];
        accountPassword = account['password'];
        accountImageName = account['imageName'];
      });
    });
  }

  // change profile
  changeProfile() async {
    // name is not empty
    if (nameController.text.isNotEmpty) {
      // account
      account.id = widget.id;
      account.name = nameController.text;
      account.email = accountEmail;
      account.password = accountPassword;
      account.imageName = accountImageName;

      // change profile
      var changeProfile = await authenticationService.updateAccount(account);

      // successfully changed profile
      if (changeProfile > 0) {
        // delete text in controller
        nameController.clear();

        if (mounted) {
          // success message
          ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
            Colors.green,
            'Berhasil mengubah profil',
          ));
        }
      }
    }
  }

  // change password
  changePassword() async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;

    // not all empty
    if (currentPassword.isNotEmpty ||
        newPassword.isNotEmpty ||
        confirmNewPassword.isNotEmpty) {
      // is one of them is empty
      if (currentPassword.isEmpty) {
        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Password saat ini harus diisi',
        ));

        return;
      } else if (newPassword.isEmpty) {
        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Password baru harus diisi',
        ));

        return;
      } else if (confirmNewPassword.isEmpty) {
        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Konfirmasi password baru harus diisi',
        ));

        return;
      }

      // the current password written down and current password are not the same
      if (currentPassword != accountPassword) {
        // delete text in controller
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Password saat ini salah',
        ));

        return;
      }

      if (newPassword.length < 8) {
        // delete text in controller
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Password baru minimal harus 8 karakter',
        ));

        return;
      }

      // new password and confirm new password are not the same
      if (newPassword != confirmNewPassword) {
        // delete text in controller
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        // error message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.red,
          'Password baru dan konfirmasi password baru tidak sama',
        ));

        return;
      }

      // account
      account.id = widget.id;
      account.name = accountName;
      account.email = accountEmail;
      account.password = newPassword;
      account.imageName = accountImageName;

      // change password
      var changePassword = await authenticationService.updateAccount(account);

      // successfully changed password
      if (changePassword > 0) {
        // delete text in controller
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();

        if (mounted) {
          // success message
          ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
            Colors.green,
            'Berhasil mengubah password, silakan masuk kembali',
          ));

          // navigate to login page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }
    }
  }

  // change image
  changeImage(String imageName) async {
    if (accountImageName != 'null' && accountImageName == imageName) {
      return;
    }

    // account
    account.id = widget.id;
    account.name = accountName;
    account.email = accountEmail;
    account.password = accountPassword;
    account.imageName = imageName;

    // change image
    var changeImage = await authenticationService.updateAccount(account);

    // successfully changed image
    if (changeImage > 0) {
      if (mounted) {
        // success message
        ScaffoldMessenger.of(context).showSnackBar(toDoSnackBar(
          Colors.green,
          imageName == 'null'
              ? 'Berhasil menghapus gambar'
              : 'Berhasil mengubah gambar',
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(id: widget.id)),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Profil', style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // photo, name & email
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: changePasswordIsPressed
                      ? const EdgeInsets.only(bottom: 150)
                      : const EdgeInsets.only(bottom: 135),
                  child: Container(
                    height: changePasswordIsPressed
                        ? MediaQuery.sizeOf(context).height / 6
                        : MediaQuery.sizeOf(context).height / 3.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),

                // photo
                Positioned(
                  top: changePasswordIsPressed
                      ? MediaQuery.sizeOf(context).height / 11
                      : MediaQuery.sizeOf(context).height / 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(65),
                      border: Border.all(
                        width: 6,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: accountImageName != ''
                          ? accountImageName == 'null'
                              ? null
                              : AssetImage('lib/images/$accountImageName')
                          : null,
                      backgroundColor: accountImageName == 'null'
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.background,
                      child: accountImageName == 'null'
                          ? accountName != ''
                              ? Text(
                                  accountName[0].toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 65,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                )
                              : null
                          : null,
                    ),
                  ),
                ),

                // camera icon
                Positioned(
                  top: changePasswordIsPressed
                      ? MediaQuery.sizeOf(context).height / 5.1
                      : MediaQuery.sizeOf(context).height / 3.3,
                  right: MediaQuery.sizeOf(context).width / 3,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (builder) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          title: Center(
                            child: Text(
                              'Pilih Gambar',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          content: SizedBox(
                            width: 250,
                            height: accountImageName == 'null' ? 385 : 470,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // first row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ToDoImage(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeImage('man.jpg');
                                        getAccount();
                                      },
                                      color: accountImageName == 'man.jpg'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      child: Image.asset(
                                        'lib/images/man.jpg',
                                        width: 105,
                                      ),
                                    ),
                                    ToDoImage(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeImage('woman.jpg');
                                        getAccount();
                                      },
                                      color: accountImageName == 'woman.jpg'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      child: Image.asset(
                                        'lib/images/woman.jpg',
                                        width: 105,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // second row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ToDoImage(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeImage('cat.jpg');
                                        getAccount();
                                      },
                                      color: accountImageName == 'cat.jpg'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      child: Image.asset(
                                        'lib/images/cat.jpg',
                                        width: 105,
                                      ),
                                    ),
                                    ToDoImage(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeImage('avocado.jpg');
                                        getAccount();
                                      },
                                      color: accountImageName == 'avocado.jpg'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      child: Image.asset(
                                        'lib/images/avocado.jpg',
                                        width: 105,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // third row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ToDoImage(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeImage('astronaut.jpg');
                                        getAccount();
                                      },
                                      color: accountImageName == 'astronaut.jpg'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      child: Image.asset(
                                        'lib/images/astronaut.jpg',
                                        width: 105,
                                      ),
                                    ),
                                    ToDoImage(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeImage('rabbit.jpg');
                                        getAccount();
                                      },
                                      color: accountImageName == 'rabbit.jpg'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      child: Image.asset(
                                        'lib/images/rabbit.jpg',
                                        width: 105,
                                      ),
                                    ),
                                  ],
                                ),

                                accountImageName == 'null'
                                    ? const SizedBox()
                                    : const SizedBox(height: 20),

                                // delete image button
                                accountImageName == 'null'
                                    ? const SizedBox()
                                    : ToDoButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          changeImage('null');
                                          getAccount();
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'Hapus Gambar',
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 23,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),

                // name & email
                Positioned(
                  top: changePasswordIsPressed
                      ? MediaQuery.sizeOf(context).height / 3.9
                      : MediaQuery.sizeOf(context).height / 2.75,
                  child: Column(
                    children: [
                      // name
                      Text(
                        accountName,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // email
                      Text(
                        accountEmail,
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // change profile and change password
            Container(
              height: changePasswordIsPressed
                  ? MediaQuery.sizeOf(context).height / 1.9
                  : MediaQuery.sizeOf(context).height / 2.36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Center(
                      child: Text(
                        changePasswordIsPressed
                            ? 'Ubah Password'
                            : 'Ubah Profil',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // name or current password
                    ToDoTextFormField(
                      controller: changePasswordIsPressed
                          ? currentPasswordController
                          : nameController,
                      inputFormatters: changePasswordIsPressed
                          ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))]
                          : null,
                      hintText: changePasswordIsPressed
                          ? 'Password saat ini'
                          : accountName,
                      prefixIcon: changePasswordIsPressed
                          ? const Icon(Icons.password_outlined)
                          : const Icon(Icons.person_outline),
                      suffixIcon: changePasswordIsPressed
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  currentPasswordIsVisisble =
                                      !currentPasswordIsVisisble;
                                });
                              },
                              icon: Icon(currentPasswordIsVisisble
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            )
                          : null,
                      obsecureText: changePasswordIsPressed
                          ? currentPasswordIsVisisble
                          : false,
                      readOnly: false,
                    ),

                    const SizedBox(height: 20),

                    // email or new password
                    ToDoTextFormField(
                      controller: changePasswordIsPressed
                          ? newPasswordController
                          : TextEditingController(),
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s'))
                      ],
                      hintText: changePasswordIsPressed
                          ? 'Password baru'
                          : accountEmail,
                      prefixIcon: changePasswordIsPressed
                          ? const Icon(Icons.password_outlined)
                          : const Icon(Icons.email_outlined),
                      suffixIcon: changePasswordIsPressed
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  newPasswordIsVisisble =
                                      !newPasswordIsVisisble;
                                });
                              },
                              icon: Icon(newPasswordIsVisisble
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            )
                          : null,
                      obsecureText: changePasswordIsPressed
                          ? newPasswordIsVisisble
                          : false,
                      readOnly: changePasswordIsPressed ? false : true,
                    ),

                    const SizedBox(height: 20),

                    // confirm password
                    changePasswordIsPressed
                        ? ToDoTextFormField(
                            controller: confirmNewPasswordController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s'))
                            ],
                            hintText: 'Konfirmasi password baru',
                            prefixIcon: const Icon(Icons.password_outlined),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  confirmNewPasswordIsVisisble =
                                      !confirmNewPasswordIsVisisble;
                                });
                              },
                              icon: Icon(confirmNewPasswordIsVisisble
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                            ),
                            obsecureText: confirmNewPasswordIsVisisble,
                            readOnly: false,
                          )
                        : const SizedBox(),

                    changePasswordIsPressed
                        ? const SizedBox(height: 20)
                        : const SizedBox(),

                    GestureDetector(
                      onTap: () {
                        // delete text in controller
                        nameController.clear();
                        currentPasswordController.clear();
                        newPasswordController.clear();
                        confirmNewPasswordController.clear();

                        setState(() {
                          changePasswordIsPressed = !changePasswordIsPressed;
                        });
                      },
                      child: Text(
                        changePasswordIsPressed
                            ? 'Ubah Profil'
                            : 'Ubah Password',
                        style: GoogleFonts.poppins(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // button
                    Row(
                      children: [
                        // cancle button
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2.35,
                          child: ToDoButton(
                            onPressed: () {
                              // delete text in controller
                              nameController.clear();
                              currentPasswordController.clear();
                              newPasswordController.clear();
                              confirmNewPasswordController.clear();
                            },
                            color: Theme.of(context).colorScheme.surface,
                            text: 'Batal',
                          ),
                        ),

                        const Spacer(),

                        // save button
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2.35,
                          child: ToDoButton(
                            onPressed: () {
                              changePasswordIsPressed
                                  ? changePassword()
                                  : changeProfile();
                              changePasswordIsPressed ? null : getAccount();
                            },
                            color: Theme.of(context).colorScheme.surface,
                            text: 'Simpan',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

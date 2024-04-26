import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/authentication/login_or_register.dart';
import 'package:todo/components/todo_drawer_tile.dart';
import 'package:todo/components/todo_snackbar.dart';
import 'package:todo/pages/profile_page.dart';
import 'package:todo/pages/settings_page.dart';
import 'package:todo/services/authentication_service.dart';

class TodoDrawerNavigation extends StatefulWidget {
  final int id;

  const TodoDrawerNavigation({super.key, required this.id});

  @override
  State<TodoDrawerNavigation> createState() => _TodoDrawerNavigationState();
}

class _TodoDrawerNavigationState extends State<TodoDrawerNavigation> {
  final authenticationService = AuthenticationService();

  // account
  String accountName = '';
  String accountEmail = '';
  String accountImageName = '';

  // get account
  getAccount() async {
    // get account by id
    dynamic account = await authenticationService.readAccountById(widget.id);

    account.forEach((account) {
      setState(() {
        accountName = account['name'];
        accountEmail = account['email'];
        accountImageName = account['imageName'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
        child: Column(
          children: [
            // user profile
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(id: widget.id)),
                );
              },
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 60,
                  backgroundImage: accountImageName != ''
                      ? accountImageName == 'null'
                          ? null
                          : AssetImage('lib/images/$accountImageName')
                      : null,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: accountImageName == 'null'
                      ? accountName != ''
                          ? Text(
                              accountName[0].toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            )
                          : null
                      : null,
                ),
                accountName: Text(
                  accountName,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                accountEmail: Text(
                  accountEmail,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),

            // home list tile
            TodoDrawerTile(
              onTap: () => Navigator.pop(context),
              icon: Icons.home_outlined,
              text: 'Beranda',
            ),

            // settings list tile
            TodoDrawerTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(id: widget.id)),
              ),
              icon: Icons.settings_outlined,
              text: 'Pengaturan',
            ),

            const Spacer(),

            // logout
            TodoDrawerTile(
              onTap: () {
                // Message
                ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
                  Colors.green,
                  20,
                  'Berhasil keluar, semangat mengerjakan semua tugas 💪',
                ));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginOrRegister()),
                );
              },
              icon: Icons.logout,
              text: 'Keluar',
            ),
          ],
        ),
      ),
    );
  }
}

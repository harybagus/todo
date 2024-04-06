import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/authentication/login_or_register.dart';
import 'package:todo/components/todo_drawer_tile.dart';

class ToDoDrawerNavigation extends StatefulWidget {
  const ToDoDrawerNavigation({super.key});

  @override
  State<ToDoDrawerNavigation> createState() => _ToDoDrawerNavigationState();
}

class _ToDoDrawerNavigationState extends State<ToDoDrawerNavigation> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
        child: Column(
          children: [
            // user profile
            GestureDetector(
              onTap: () {},
              child: UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://source.unsplash.com/500x500?man'),
                ),
                accountName: Text(
                  "Bagus Hary",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                accountEmail: Text(
                  "bagusbanget@gmail.com",
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
            ToDoDrawerTile(
              onTap: () => Navigator.pop(context),
              icon: Icons.home_outlined,
              text: 'Beranda',
            ),

            // all categories list tile
            ToDoDrawerTile(
              onTap: () {},
              icon: Icons.edit_note_outlined,
              text: 'Semua kategori',
            ),

            // all todos list tile
            ToDoDrawerTile(
              onTap: () {},
              icon: Icons.edit_outlined,
              text: 'Semua tugas',
            ),

            // settings list tile
            ToDoDrawerTile(
              onTap: () {},
              icon: Icons.settings_outlined,
              text: 'Pengaturan',
            ),

            const Spacer(),

            // logout
            ToDoDrawerTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginOrRegister()),
              ),
              icon: Icons.logout,
              text: 'Keluar',
            ),
          ],
        ),
      ),
    );
  }
}

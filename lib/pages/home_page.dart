import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_calendar.dart';
import 'package:todo/components/todo_day.dart';
import 'package:todo/components/todo_drawer_navigation.dart';
import 'package:todo/components/todo_logo.dart';
import 'package:todo/components/todo_month.dart';
import 'package:todo/components/todo_search.dart';

class HomePage extends StatefulWidget {
  final int? id;

  const HomePage({super.key, this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // current time
  DateTime today = DateTime.now();

  // on day selected
  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      calendarIconIsPressed = !calendarIconIsPressed;
    });
  }

  // calendar icon is pressed
  bool calendarIconIsPressed = false;

  // text editing controllers
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const ToDoLogo(fontSize: 23),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                calendarIconIsPressed = !calendarIconIsPressed;
              });
            },
            icon: Icon(calendarIconIsPressed
                ? Icons.calendar_today_outlined
                : Icons.calendar_month_outlined),
          )
        ],
      ),
      drawer: const ToDoDrawerNavigation(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // search
                ToDoSearch(
                  onChanged: (value) {},
                  controller: searchController,
                  text: 'Cari tugas',
                ),

                const SizedBox(height: 20),

                // day & date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // day
                    Text(
                      day(today),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // date
                    Text(
                      "${today.day} ${month(today)} ${today.year}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                // calendar
                calendarIconIsPressed
                    ? ToDoCalendar(
                        focusedDay: today, onDaySelected: onDaySelected)
                    : const SizedBox(height: 0),

                const SizedBox(height: 20),

                // categories
                Text(
                  "Kategori",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // todos
                Text(
                  "Tugas",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

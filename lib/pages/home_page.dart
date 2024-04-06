import 'package:flutter/material.dart';
import 'package:todo/components/todo_drawer_navigation.dart';
import 'package:todo/components/todo_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_outlined),
          )
        ],
      ),
      drawer: const ToDoDrawerNavigation(),
    );
  }
}

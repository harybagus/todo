import 'package:flutter/material.dart';

class ToDoImage extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final Widget child;

  const ToDoImage({
    super.key,
    required this.onTap,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 5,
            color: color,
          ),
        ),
        child: child,
      ),
    );
  }
}

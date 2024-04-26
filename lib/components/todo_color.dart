import 'package:flutter/material.dart';

class TodoColor extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final Widget? child;

  const TodoColor({
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
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: child,
      ),
    );
  }
}

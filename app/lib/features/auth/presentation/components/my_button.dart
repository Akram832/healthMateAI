import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(100, 0, 0, 0),
                  offset: Offset(1.0, 1.0),
                  blurRadius: 15,
                  spreadRadius: 1.0)
            ],
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(
                    255, 0, 180, 216), // Light blue color for the top
                Color.fromARGB(255, 2, 124, 148), // Ending color (green)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18),
          ),
        ),
      ),
    );
  }
}

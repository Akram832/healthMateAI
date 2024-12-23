import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? icon;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12), // Ensure radius is set here
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          hintText: hintText,
          hintStyle:
              TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          fillColor: const Color.fromARGB(224, 255, 255, 255),
          filled: true,
          prefixIcon: icon != null
              ? Icon(icon, color: Theme.of(context).colorScheme.inversePrimary)
              : null,
        ),
      ),
    );
  }
}

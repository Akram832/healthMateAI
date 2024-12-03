import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const TextInput({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        controller: controller,
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
          hintStyle:
              TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
        ),
      ),
    );
  }
}

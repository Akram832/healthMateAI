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
        style: TextStyle(color: Colors.white, decoration: TextDecoration.none),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromARGB(255, 251, 246, 246)),
          filled: true,
          fillColor: const Color.fromARGB(58, 255, 255, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }
}

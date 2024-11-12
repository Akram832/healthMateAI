import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
      surface: Colors.grey.shade300,
      primary: const Color.fromARGB(255, 255, 255, 255),
      secondary: Colors.grey.shade200,
      tertiary: Colors.grey.shade100,
      inversePrimary: Colors.grey.shade800),
  scaffoldBackgroundColor: Colors.transparent,
);

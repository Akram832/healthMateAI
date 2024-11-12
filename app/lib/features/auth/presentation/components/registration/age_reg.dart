import 'package:flutter/material.dart';

class BirthDateReg extends StatelessWidget {
  const BirthDateReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 3, 124, 148), // Light blue color for the top
            Color.fromARGB(255, 7, 199, 148), // Ending color (green)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

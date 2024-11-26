import 'package:app/features/auth/presentation/components/date_input.dart';
import 'package:flutter/material.dart';

class BirthDateReg extends StatelessWidget {
  const BirthDateReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Light blue color for the top
            Color.fromARGB(255, 2, 105, 149),
            Color.fromARGB(255, 25, 40, 56), // Ending color (green)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Image.asset(
              "lib/features/auth/presentation/asset/images/age.png",
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Age",
              style: TextStyle(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Select your age. ",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 40),
          MyDateInput(text: 'select your age')
        ],
      ),
    );
  }
}

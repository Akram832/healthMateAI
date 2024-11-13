import 'package:app/features/auth/presentation/components/my_text_feild.dart';
import 'package:flutter/material.dart';

class FullNameReg extends StatefulWidget {
  const FullNameReg({super.key});

  @override
  State<FullNameReg> createState() => _FullNameRegState();
}

class _FullNameRegState extends State<FullNameReg> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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
              "lib/features/auth/presentation/asset/images/login.png",
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Create Your Profile",
              style: TextStyle(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Kindly provide your first and last name to proceed. ",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 20),
          MyTextField(
              controller: firstNameController,
              hintText: "First Name",
              obscureText: false,
              icon: Icons.person_outline),
          const SizedBox(height: 25),
          MyTextField(
              controller: lastNameController,
              hintText: "Last Name",
              obscureText: false,
              icon: Icons.person_outline)
        ],
      ),
    );
  }
}

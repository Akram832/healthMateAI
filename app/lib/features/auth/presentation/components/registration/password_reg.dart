import 'package:app/features/auth/presentation/components/my_text_feild.dart';
import 'package:flutter/material.dart';

class PasswordReg extends StatefulWidget {
  const PasswordReg({super.key});

  @override
  State<PasswordReg> createState() => _PasswordRegState();
}

class _PasswordRegState extends State<PasswordReg> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

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
              "lib/features/auth/presentation/asset/images/password.png",
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Secure Your Account",
              style: TextStyle(
                  fontSize: 36,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "Enter your password to proceed ",
            style: TextStyle(
                fontSize: 15, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 20),
          MyTextField(
              controller: passwordController,
              hintText: "passowrd",
              obscureText: true,
              icon: Icons.mail_outline),
          const SizedBox(height: 20),
          MyTextField(
              controller: passwordController,
              hintText: "confirme passowrd",
              obscureText: true,
              icon: Icons.mail_outline),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

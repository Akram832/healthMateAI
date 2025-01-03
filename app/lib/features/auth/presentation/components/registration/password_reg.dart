import 'package:app/features/auth/presentation/components/my_text_feild.dart';
import 'package:flutter/material.dart';

class PasswordReg extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordReg({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

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
      child: SingleChildScrollView(
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
                hintText: "Password",
                obscureText: false,
                icon: Icons.lock_outline),
            const SizedBox(height: 20),
            MyTextField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: false,
                icon: Icons.lock_outline),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

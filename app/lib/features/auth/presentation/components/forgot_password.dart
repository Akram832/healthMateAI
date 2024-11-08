import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final Function()? onTap;
  const ForgotPassword({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        "Forgot Password?",
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w300),
      ),
    );
  }
}

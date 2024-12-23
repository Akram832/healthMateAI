import 'package:app/features/auth/presentation/components/forgot_password.dart';
import 'package:app/features/auth/presentation/components/my_button.dart';
import 'package:app/features/auth/presentation/components/my_text_feild.dart';
import 'package:app/features/auth/presentation/components/swith_button.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void resetPassword() {}
  bool isSwitchOn = false;

  void login() {
    final String email = emailController.text;
    final String pw = passwordController.text;

    final authCubit = context.read<AuthCubits>();
    if (email.isNotEmpty && pw.isNotEmpty) {
      authCubit.login(email, pw);
    } else {
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter your email")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter your password")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40), // Space from the top
                    // Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Image.asset(
                        "lib/features/auth/presentation/asset/images/login.png",
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Message
                    Text(
                      "Welcome Back, you've been missed!",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 15),

                    // Email text field
                    MyTextField(
                      controller: emailController,
                      hintText: "email",
                      obscureText: false,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 20),

                    // Password text field
                    MyTextField(
                      controller: passwordController,
                      hintText: "password",
                      obscureText: true,
                      icon: Icons.lock_outline_sharp,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchButton(text: "Remember me"),
                        Spacer(),
                        ForgotPassword(onTap: resetPassword),
                      ],
                    ),

                    const SizedBox(height: 20),

                    MyButton(
                      text: 'SUBMIT',
                      onTap: login,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  Divider(color: Colors.white, thickness: 1.5)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Or continue with",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                              child:
                                  Divider(color: Colors.white, thickness: 1.5)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(),
                        child: Image.asset(
                            "lib/features/auth/presentation/asset/images/google.png"),
                      ),
                    ),

                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        GestureDetector(
                          onTap: widget.togglePages,
                          child: Text(
                            'Register now',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Space from the bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

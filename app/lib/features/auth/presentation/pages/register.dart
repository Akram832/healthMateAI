import 'package:app/features/auth/presentation/components/registration/age_reg.dart';
import 'package:app/features/auth/presentation/components/registration/email_reg.dart';
import 'package:app/features/auth/presentation/components/registration/gender_reg.dart';
import 'package:app/features/auth/presentation/components/registration/name_reg.dart';
import 'package:app/features/auth/presentation/components/registration/password_reg.dart';
import 'package:app/features/chat_bot/presentation/pages/chat_bot_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:app/features/auth/presentation/cubits/auth_states.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  // Placeholder controllers for collecting data from the pages
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime selectedDate = DateTime(2000, 1, 1);
  bool isregistered = false;

  void register() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    isregistered = true; // make sure that the user has successfully registered

    final authCubit = context.read<AuthCubits>();
    authCubit.register(email, password, lastName, firstName, 0, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubits, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is Authenticated && isregistered) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context); // Dismiss loading dialog
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatBotPage()), // Replace with your HomePage
          );
        } else if (state is AuthError) {
          Navigator.pop(context); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      onLastPage = (index == 4);
                    });
                  },
                  children: [
                    FullNameReg(
                      firstNameController: firstNameController,
                      lastNameController: lastNameController,
                    ),
                    GenderReg(),
                    BirthDateReg(
                      onDateSelected: (date) => selectedDate = date,
                    ),
                    EmailPage(emailController: emailController),
                    PasswordReg(
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                    ),
                  ],
                ),
                Container(
                  alignment: const Alignment(0, 0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 5,
                        effect: const SlideEffect(activeDotColor: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (onLastPage) {
                            register();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        child: Text(
                          onLastPage ? "Done" : "Next",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: const Center(child: Text("Welcome to the Home Page!")),
    );
  }
}

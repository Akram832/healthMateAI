import 'package:app/features/auth/presentation/components/my_button.dart';
import 'package:app/features/auth/presentation/components/my_text_feild.dart';
import 'package:app/features/auth/presentation/components/registration/age_reg.dart';
import 'package:app/features/auth/presentation/components/registration/email_reg.dart';
import 'package:app/features/auth/presentation/components/registration/gender_reg.dart';
import 'package:app/features/auth/presentation/components/registration/name_reg.dart';
import 'package:app/features/auth/presentation/components/registration/password_reg.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              children: [
                FullNameReg(),
                GenderReg(),
                BirthDateReg(),
                EmailPage(),
                PasswordReg()
              ],
            ),
            Container(
              alignment: Alignment(0, 0.85),
              child: SmoothPageIndicator(controller: _controller, count: 5),
            )
          ],
        ),
      ),
    );
  }
}

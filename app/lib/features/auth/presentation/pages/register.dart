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
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
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
                FullNameReg(),
                GenderReg(),
                BirthDateReg(),
                EmailPage(),
                PasswordReg()
              ],
            ),
            Container(
              alignment: Alignment(0, 0.85),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _controller.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.white),
                        )),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 5,
                      effect: SlideEffect(activeDotColor: Colors.white),
                    ),
                    onLastPage
                        ? GestureDetector(
                            onTap: () {
                              _controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Text(
                              "Done",
                              style: TextStyle(color: Colors.white),
                            ))
                        : GestureDetector(
                            onTap: () {
                              _controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

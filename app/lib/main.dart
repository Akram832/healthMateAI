import 'package:app/features/auth/presentation/pages/auth_page.dart';

import 'package:app/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      title: 'HealthMate',
      home: AuthPage(),
    );
  }
}

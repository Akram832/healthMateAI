import 'package:app/const.dart';
import 'package:app/features/auth/data/firebase_auth_repo.dart';
import 'package:app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:app/firebase_options.dart';
import 'package:app/theme/light_theme.dart';
import 'package:app/features/auth/presentation/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Instantiate the repository
  final FirebaseAuthRepo authRepo = FirebaseAuthRepo();
  Gemini.init(apiKey: apiKey);
  runApp(MyApp(authRepo: authRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepo authRepo;

  const MyApp({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubits(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        title: 'HealthMate',
        home: const AuthPage(),
      ),
    );
  }
}

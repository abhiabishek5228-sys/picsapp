import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picsapp/provider/logic.dart';
import 'package:picsapp/screens/admin/user/signup.dart';
// import 'firebase_options.dart'; // <-- Uncomment this if you ran "flutterfire configure"

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // <-- Uncomment this if you have firebase_options.dart
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pices',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SignUpScreen(), // Or SignInScreen
    );
  }
}
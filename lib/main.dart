
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:picsapp/firebase_options.dart';
import 'package:picsapp/provider/homeprovider.dart';
import 'package:picsapp/provider/logic.dart';
import 'package:picsapp/screens/admin/user/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Hive
  await Hive.initFlutter();
// local storage

await Hive.openBox<String>("favorites");
await Hive.openBox<String>("downloads");


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInProvider>(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider<SignUpProvider>(
          create: (_) => SignUpProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
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
      home: const SignUpScreen(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_173/firebase_options.dart';
import 'package:firebase_173/note_model.dart';
import 'package:firebase_173/onboarding/login_page.dart';
import 'package:firebase_173/onboarding/sign_up_page.dart';
import 'package:firebase_173/splash_page.dart';
import 'package:firebase_173/user_profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}


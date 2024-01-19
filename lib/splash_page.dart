import 'dart:async';

import 'package:firebase_173/home_page.dart';
import 'package:firebase_173/onboarding/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () async {

      var prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString("userId");

      Widget toNextPage = LoginPage();

      if(userId!=null){
        if(userId!=""){
          toNextPage = HomePage(userId: userId);
        }
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => toNextPage,));


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Fire173', style: TextStyle(fontSize: 34),),
      ),
    );
  }
}

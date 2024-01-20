import 'package:firebase_173/main.dart';
import 'package:firebase_173/onboarding/mobile_login_page.dart';
import 'package:firebase_173/onboarding/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hi!, Welcome back..',
              style: TextStyle(fontSize: 34),
            ),
            SizedBox(
              height: 21,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  label: Text('Email'),
                  hintText: 'Enter your Email here..',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11))),
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                  label: Text('Password'),
                  hintText: 'Enter your Password here..',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11))),
            ),
            SizedBox(
              height: 21,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      var auth = FirebaseAuth.instance;

                      try {
                        var userCred = await auth.signInWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passController.text.toString());

                        ///add shared pref here
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString("userId", userCred.user!.uid);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(userId: userCred.user!.uid),
                            ));
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Uhh..No!!, Error Occured: $e')));
                        /* if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }*/
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Uhh..No!!, Error Occured: $e')));
                      }
                    },
                    child: Text('Sign In'))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an Account,"),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ));
                    },
                    child: Text(
                      " Create Now..",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            SizedBox(
              height: 11,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MobileLoginPage(),));
                },
                child: Text("Login with Mobile No"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

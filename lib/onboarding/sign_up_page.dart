import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              style: TextStyle(fontSize: 34),
            ),
            SizedBox(
              height: 21,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  label: Text('Name'),
                  hintText: 'Enter your Name here..',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11))),
            ),
            SizedBox(
              height: 11,
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
                    onPressed: () async{
                      var auth = FirebaseAuth.instance;
                      var firestore = FirebaseFirestore.instance;

                      try {
                       var userCred = await auth.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passController.text.toString());

                       var UUID = userCred.user!.uid;
                       var createdAt = DateTime.now().millisecondsSinceEpoch;

                       firestore.collection("users").doc(UUID).set({
                         'name' : nameController.text.toString(),
                         'email' : userCred.user!.email,
                         'createdAt' : createdAt
                       });

                       Navigator.pop(context);


                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uhh..No!!, Error Occured: $e')));
                      }
                    },
                    child: Text('Sign Up'))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an Account,"),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      " Login Now..",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

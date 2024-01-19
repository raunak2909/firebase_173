import 'package:firebase_173/onboarding/otp_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileLoginPage extends StatelessWidget{
  var mobNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login with Mobile No.', style: TextStyle(fontSize: 25),),
          TextField(
            controller: mobNoController,
          ),
          ElevatedButton(onPressed: () async {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91${mobNoController.text.toString()}',
              verificationCompleted: (PhoneAuthCredential credential) {
                print("Verification completed!!");
              },
              verificationFailed: (FirebaseAuthException e) {
                print("Verification failed!!");
              },
              codeSent: (String verificationId, int? resendToken) {
                // navigate to next page (OTP screen)
                Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationPage(mVerificationId: verificationId),));
              },
              codeAutoRetrievalTimeout: (String verificationId) {

              },
            );
          }, child: Text('Send OTP'))
        ],
      ),
    );
  }
}
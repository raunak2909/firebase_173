import 'package:firebase_173/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationPage extends StatefulWidget {
  String mVerificationId;

  OtpVerificationPage({required this.mVerificationId});

  @override
  State<OtpVerificationPage> createState() => _otpVerificationPageState();
}

class _otpVerificationPageState extends State<OtpVerificationPage> {
  //List<TextEditingController> _controllers = [];
  //List<FocusNode> _focusedNode =[];
  var otp1Controller = TextEditingController();
  var otp2Controller = TextEditingController();
  var otp3Controller = TextEditingController();
  var otp4Controller = TextEditingController();
  var otp5Controller = TextEditingController();
  var otp6Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_controllers = List.generate(6, (index) => TextEditingController());
    //_focusedNode = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    super.dispose();
  }

  //FocusNode node1 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verfication",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Enter the OTP send to your number",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              myTextField(controller: otp1Controller, mFocus: true),
              myTextField(controller: otp2Controller, mFocus: false),
              myTextField(controller: otp3Controller, mFocus: false),
              myTextField(controller: otp4Controller, mFocus: false),
              myTextField(controller: otp5Controller, mFocus: false),
              myTextField(controller: otp6Controller, mFocus: false),
            ]),
            SizedBox(
              height: 25,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                    onPressed: () async {
                      if (otp1Controller.text.isNotEmpty &&
                          otp2Controller.text.isNotEmpty &&
                          otp3Controller.text.isNotEmpty &&
                          otp4Controller.text.isNotEmpty &&
                          otp5Controller.text.isNotEmpty &&
                          otp6Controller.text.isNotEmpty) {
                        var otpCode =
                            "${otp1Controller.text.toString()}${otp2Controller.text.toString()}${otp3Controller.text.toString()}${otp4Controller.text.toString()}${otp5Controller.text.toString()}${otp6Controller.text.toString()}";

                        var credential = PhoneAuthProvider.credential(
                            verificationId: widget.mVerificationId,
                            smsCode: otpCode);

                        var auth = FirebaseAuth.instance;

                        var userCred =
                            await auth.signInWithCredential(credential);

                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString("userId", userCred.user!.uid);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(userId: userCred.user!.uid),
                            ));
                      }
                    },
                    child: Text("Submit")))
          ],
        ),
      ),
    );
  }

  Widget myTextField(
      {required TextEditingController controller, required bool mFocus}) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        cursorColor: Colors.white,
        maxLength: 1,
        textAlign: TextAlign.center,
        autofocus: mFocus,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterText: "",
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:phone_verification/screens/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,//there are two states created here ,which are used for the change of screen while opening the app
  SHOW_OTP_FORM_STATE,//This is otp screen state which is triggered when an otp is sent successfully to the entered mobile number
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();//This is the main class where LoginScreen state is called
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;//At first when you open an app the mobile form state should be visible where you can enter the mobile number

  final phoneController = TextEditingController();//This is the text field for mobile number
  final otpController = TextEditingController();//this is the text field for otp

  FirebaseAuth _auth = FirebaseAuth.instance;//this is used for the authentication for the new and existing user

  String verificationId;//a string variable for verification is created

  bool showLoading = false;//this variable is used to show the loading page in an app

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true; //setstate is used to update the screen UI farme by frame
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);//await is keyword used to get the result after the operation gets completed

      setState(() {
        showLoading = false;
      });

      if (authCredential?.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));//if the credential is not null then tit logs in
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text(e.message)));//this will show the messaage if anything goea wring while logging in 
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,//this loads he mobile number 
          decoration: InputDecoration(
            hintText: "Phone Number",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {//this is function called when you press a button  and all the following functions triggers
            setState(() {
              showLoading = true;
            });
            FirebaseAuth.instance.authStateChanges().listen((User user) {
              if (user != null)
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));//if the user is already logged in then it logins and takes to homescreen
            });
            await _auth.verifyPhoneNumber(//This is a asynchronous function to verify the mobile number
              phoneNumber: '+91' + phoneController.text,//+91 is used as a indian mobile code so we already stated so we can directly nter the mobile number
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                signInWithPhoneAuthCredential(phoneAuthCredential);//f the number is verified precisely the we call signin funtion with the number
              },
              verificationFailed: (verificationFailed) async {
                // Text(
                //   "Please check the number and re-enter",
                //   style: TextStyle(color: Colors.amberAccent, fontSize: 15),
                // );
                setState(() {
                  showLoading = false;
                });
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text(verificationFailed.message)));//we output the reason for failed verification
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  // Text(
                  //   "A code has been sent to the number",
                  // );
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;//if the code is sent successfully to the mobile number we channge the mobile state to otp state where the setstate is called so it will show  the otp screen where we have to enter otp
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text("SEND"),//this is just a text on that button
          color: Colors.blue,//properties of the flat button
          textColor: Color.fromARGB(255, 246, 235, 235),
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {//this widget is called when the otp is been sent successfully
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,//otp that we have entered is loaded
          decoration: InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(//this button is pressed to login to the homescreen and verifiaction of otp 
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),//text on the button
          color: Colors.blue,//properties of button
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {//this build widget gets loaded frame by frame whenever setstate is called 
    return Scaffold(
        key: _scaffoldKey,
        body: Container(//this are all stored in a container
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)//if the current state is mobile login it willl take to the mobile enter page
                  : getOtpFormWidget(context),//or else otp screen
          padding: const EdgeInsets.all(16),
        ));
  }
}

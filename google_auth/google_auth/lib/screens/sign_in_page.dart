// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_auth/services/firebase_service.dart';
import 'package:google_auth/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;//Media Query is used to create the right layout
    OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));//specifications of border size
    return Scaffold(
        resizeToAvoidBottomInset: false,//it resizes the keyboard size and the body and scaffold widgets
        backgroundColor: Constants.kPrimaryColor,//background colour
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Image.asset("assets/images/sign-in.png"),
          // RichText(
          //     textAlign: TextAlign.center,
          //     text: TextSpan(children: <TextSpan>[
          //       TextSpan(
          //           text: Constants.textSignInTitle,
          //           style: TextStyle(
          //             color: Constants.kBlackColor,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 30.0,
          //           )),
          //     ])),
          Text("RAAT RANI 77",
              style: TextStyle( //text specifications
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 30)),
          Image.asset("assets/logo.png"),//bus logo
          SizedBox(height: size.height * 0.01),
          // Text(
          //   Constants.textSmallSignIn,
          //   style: TextStyle(color: Constants.kDarkGreyColor),
          // ),
          GoogleSignIn(),//Goole sign in class gets called
          // buildRowDivider(size: size),
          // Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
          // SizedBox(
          //   width: size.width * 0.8,
          //   child: TextField(
          //       decoration: InputDecoration(
          //           contentPadding:
          //               EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          //           enabledBorder: border,
          //           focusedBorder: border)),
          // ),
          // SizedBox(
          //   height: size.height * 0.01,
          // ),
          // SizedBox(
          //   width: size.width * 0.8,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       contentPadding:
          //           EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          //       enabledBorder: border,
          //       focusedBorder: border,
          //       suffixIcon: Padding(
          //         child: FaIcon(
          //           FontAwesomeIcons.eye,
          //           size: 15,
          //         ),
          //         padding: EdgeInsets.only(top: 15, left: 15),
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
          // SizedBox(
          //   width: size.width * 0.8,
          //   child: OutlinedButton(
          //     onPressed: () async {},
          //     child: Text(Constants.textSignIn),
          //     style: ButtonStyle(
          //         foregroundColor:
          //             MaterialStateProperty.all<Color>(Constants.kPrimaryColor),
          //         backgroundColor:
          //             MaterialStateProperty.all<Color>(Constants.kBlackColor),
          //         side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
          //   ),
          // ),
          // RichText(
          //     textAlign: TextAlign.center,
          //     text: TextSpan(children: <TextSpan>[
          //       TextSpan(
          //           text: Constants.textAcc,
          //           style: TextStyle(
          //             color: Constants.kDarkGreyColor,
          //           )),
          //       TextSpan(
          //           text: Constants.textSignUp,
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             color: Constants.kDarkBlueColor,
          //           )),
          //     ])),
        ])));
  }

  // Widget buildRowDivider({required Size size}) {
  //   return SizedBox(
  //     width: size.width * 0.8,
  //     child: Row(children: <Widget>[
  //       Expanded(child: Divider(color: Constants.kDarkGreyColor)),
  //       Padding(
  //           padding: EdgeInsets.only(left: 8.0, right: 8.0),
  //           child: Text(
  //             "Or",
  //             style: TextStyle(color: Constants.kDarkGreyColor),
  //           )),
  //       Expanded(child: Divider(color: Constants.kDarkGreyColor)),
  //     ]),
  //   );
  // }
}

class GoogleSignIn extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;//this is used to show circular progress indicator

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton.icon(//this is text button
              icon: FaIcon(FontAwesomeIcons.google),//This is used to get the Google icon 
              onPressed: () async {
                setState(() {
                  isLoading = true;//This will show the loading screen and refresh 
                });
                FirebaseService service = new FirebaseService();//This is the backend-service
                try {
                  await service.signInwithGoogle();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamedAndRemoveUntil(
                      context, Constants.homeNavigate, (route) => false);//this will navigate to homescreen after logging in successfully
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
                setState(() {
                  isLoading = false;
                });
              },
              label: Text(//Declaring the label and its properties
                Constants.textSignInGoogle,
                style: TextStyle(
                    color: Constants.kBlackColor, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(//properties of button
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.kGreyColor),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            ),
          )
        : CircularProgressIndicator();
  }

  void showMessage(String message) {//function to show the error
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

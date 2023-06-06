import 'package:google_auth/screens/sign_in_page.dart';
import 'package:google_auth/screens/homepage.dart';
import 'package:google_auth/screens/welcome_page.dart';
import 'package:flutter/material.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    // '/': (context) => WelcomePage(),
    '/sign-in': (context) => SignInPage(),//This is used if the user wants to sign in it takes to the sign in page
    '/home': (context) => HomePage()// This will take to the homepage
  };
}

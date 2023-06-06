import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_auth/services/firebase_service.dart';
import 'package:google_auth/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  //This is a stateful widget for the Homescreen
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance
      .currentUser; //It checks the credentals of the user at this particular instance
  @override
  void initState() {
    // this is called when the class is initialized or called for the first time
    super
        .initState(); //  this is the material super constructor for init state to link your instance initState to the global initState context
  }

  @override
  Widget build(BuildContext context) {
    //This is used for Build method
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout, //This is an Icon used for logout
                color: Colors.red,
              ),
              onPressed: () async {
                FirebaseService service = new FirebaseService();
                await service.signOutFromGoogle();
                Navigator.pushReplacementNamed(
                    context, Constants.signInNavigate);
              },
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
          title: Text("Home"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user!.email!), //We display user email account
            Text(user!.displayName!), //It displays the username of the emai;
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
              radius: 20,
            )
          ],
        )));
  }
}

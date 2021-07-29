import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_1/bussiness/authentication.dart';
import 'package:todolist_1/pages/homepage.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? user;

  @override
  void initState() {
    authUser.checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Just Do It.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50.0,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
        ),
        GestureDetector(
          onTap: () {
            authUser.googlesignin().whenComplete(() => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  ),
                });
          },
          child: Image.asset(
            'assets/images/google_signin_button.png',
            width: MediaQuery.of(context).size.width,
            height: 50.0,
          ),
        ),
      ]),
    );
  }
}

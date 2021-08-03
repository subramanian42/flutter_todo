import 'package:flutter/material.dart';

import 'package:todolist_1/bussiness/authentication.dart';
import 'package:todolist_1/pages/homepage.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // authenticatedUser.checkUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 60,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                authenticatedUser.googlesignin().whenComplete(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  );
                });
              },
              child: Image.asset(
                'assets/images/google_signin_button.png',
                width: MediaQuery.of(context).size.width,
                height: 50.0,
              ),
            ),

            /*       GestureDetector(
            onTap: () {
                authenticatedUser.googlesignin().whenComplete(() {
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
          ), */
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todolist_1/bussiness/authentication.dart';
//import 'package:todolist_1/pages/AddTask.dart';
import 'package:todolist_1/pages/homepage.dart';

import 'package:todolist_1/pages/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authUser.firebaseAuth.currentUser != null
          ? HomePage()
          : SignInScreen(),

/*       initialRoute: '/',
      routes: {
        ' /': (context) {
          if (authUser.firebaseAuth.currentUser != null) return HomePage();

          return SignInScreen();
        },
        ' /second': (context) {
          if (authUser.firebaseAuth.currentUser != null) return AddTask();
          return SignInScreen();
        },
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => SignInScreen()), */
    );
  }
}

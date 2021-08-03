import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:todolist_1/bussiness/authentication.dart';
import 'package:todolist_1/pages/homepage.dart';
import 'package:todolist_1/pages/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
/*   FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
 */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAuth.instance.authStateChanges().first;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? HomePage()
          : SignInScreen(),
    );
  }
}

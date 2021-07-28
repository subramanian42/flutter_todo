//import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:todolist_1/bussiness/authentication.dart';
import 'package:todolist_1/pages/AddTask.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:todolist_1/pages/taskmanager.dart';
//import 'sign_in_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  late FirebaseAuth firebaseAuth = FirebaseAuth.instance;
/*   Future<void> signOut() async {
    await firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            authUser.signOut();
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/images/log-out-symbol.png',
            width: 20,
            height: 20,
          ),
        ),
        title: Center(
          child: Text(
            'Just Do it.',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'assets/fonts/static/PlayfairDisplay-Bold.ttf'),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: TaskManager(), //TaskList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddTask())),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}

/* import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
 */

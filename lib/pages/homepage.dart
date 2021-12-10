import 'package:flutter/material.dart';
import 'package:todolist_1/business/authentication.dart';
import 'package:todolist_1/pages/sign_in_screen.dart';
import 'taskmanager.dart';
import 'package:todolist_1/pages/AddTask.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await authenticatedUser.signOut();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignInScreen();
              }));
            }
          },
          icon: Image.asset(
            'assets/images/log-out-symbol.png',
            width: 15,
            height: 20,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Just Do it.',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'assets/fonts/static/PlayfairDisplay-Bold.ttf'),
        ),
        backgroundColor: Colors.white,
      ),
      body: TaskManager(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddTask();
          }));
        },
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

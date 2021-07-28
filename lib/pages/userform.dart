import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? username;

    submit() {
      _formKey.currentState?.save();
      Navigator.pop(context, username);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Setup Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: 25.0),
            child: Center(
              child: Text(
                'Enter a username',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                onSaved: (val) => username = val,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: submit(),
            child: Container(
              color: Colors.black,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(7.0)),
              child: Text(
                'submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

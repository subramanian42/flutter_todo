import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todolist_1/bussiness/authentication.dart';

class AddTask extends StatefulWidget {
  //const TaskBuild({Key? key}) : super(key: key);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? selectedDate;
  //static var userid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference taskRef = FirebaseFirestore.instance
      .collection('users')
      .doc(authUser.firebaseAuth.currentUser!.uid)
      .collection('Task');
  @override
  void initState() {
    _dateController.text = DateFormat('d/M/y').format(DateTime.now());
    super.initState();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.grey;
    }
    return Colors.black;
  }

  setDate(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2102),
    );
    setState(() {
      selectedDate = picked;
      _dateController.text = DateFormat('d/M/y').format(selectedDate!);
    });
  }

  createTask(
    String title,
    String details,
    bool status,
    String date,
  ) async {
    var id1 = taskRef.doc().id;
    await taskRef.doc(id1).set({
      'id': id1,
      'TaskTitle': title,
      'TaskDetails': details,
      'TaskStatus': status,
      'DueDate': date,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                size: 30.0,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      maxLength: 20,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      cursorColor: Colors.black,
                      controller: _titleController,
                      decoration: InputDecoration(
                        /*  fillColor: Colors.black,
                        focusColor: Colors.black,
                        hoverColor: Colors.black, */
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        labelText: 'TaskTitle',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Enter TaskTitle',
                        hintStyle: TextStyle(
                          fontFamily:
                              'assets/fonts/georgia/Georgia Regular font.ttf',
                          fontSize: 10.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _taskController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'TaskDetails',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Enter Task Details',
                        hintStyle: TextStyle(
                          fontFamily:
                              'assets/fonts/georgia/Georgia Regular font.ttf',
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'DUE DATE:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_dateController.text),
                        TextButton(
                          onPressed: () {
                            setDate(context);
                          },
                          child: Text(
                            'PICK DATE',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith(getColor)),
                        onPressed: () {
                          createTask(
                              _titleController.text,
                              _taskController.text,
                              false,
                              _dateController.text);

                          Navigator.of(context).pop();
                        },
                        child: Text('ADD TASK')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

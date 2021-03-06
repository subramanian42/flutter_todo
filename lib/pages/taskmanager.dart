import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:todolist_1/business/authentication.dart';
import 'package:todolist_1/widgets/task.dart';

class TaskManager extends StatefulWidget {
  TaskManager({Key? key}) : super(key: key);

  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  DateTime? selectedDate = DateTime.now();

  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _taskcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  updateTask(docid) {
    authenticatedUser.getTaskReference().doc(docid).update({
      'TaskTitle': _titlecontroller.text,
      'TaskDetails': _taskcontroller.text,
      'TaskStatus': false,
      'DueDate': _datecontroller.text,
    });
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
      _datecontroller.text = DateFormat('d/M/y').format(selectedDate!);
    });
  }

  dialogbox(String docid, String tasktitle, String duedate, String details) {
    _titlecontroller.text = tasktitle;
    _datecontroller.text = duedate;
    _taskcontroller.text = details;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              //context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              labelText: 'TaskTitle',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintText: 'Enter TaskTitle',
                              hintStyle: TextStyle(
                                //fontFamily: 'assets/fonts/georgia/Georgia Regular font.ttf',
                                fontSize: 10.0,
                              ),
                            ),
                            controller: _titlecontroller),
                        TextField(
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          minLines: null,
                          maxLines: null,
                          controller: _taskcontroller,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            // border: InputBorder.none,
                            labelText: 'TaskDetails',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: 'Enter Task Details',
                            hintStyle: TextStyle(
                              //fontFamily: 'assets/fonts/georgia/Georgia Regular font.ttf',
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'DUE DATE:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(_datecontroller.text),
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
                        Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          getColor)),
                              onPressed: () {
                                updateTask(docid);
                                Navigator.pop(context);
                              },
                              child: Text('UPDATE TASK')),
                        ),
                      ],
                    ),
                  );
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: authenticatedUser.tasklist(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data!.size > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Map<String, dynamic>> userDa =
                        snapshot.data!.docs[index];
                    return Dismissible(
                      key: UniqueKey(),
                      child: InkWell(
                        onTap: () {
                          dialogbox(
                            userDa.data()['id'],
                            userDa.data()['TaskTitle'],
                            userDa.data()['DueDate'],
                            userDa.data()['TaskDetails'],
                          );
                        },
                        //starting of statless widget
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SizedBox(
                            height: 100,
                            child: Card(
                              elevation: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Checkbox(
                                      value: userDa.data()['TaskStatus'],
                                      onChanged: (status) async {
                                        await authenticatedUser
                                            .getTaskReference()
                                            .doc(userDa.data()['id'])
                                            .update({
                                          'TaskStatus': status,
                                        });
                                      }),
                                  Taskcard(
                                    title: userDa.data()['TaskTitle'],
                                    subtitle: userDa.data()['TaskDetails'],
                                    dueDate: userDa.data()['DueDate'],
                                    taskStatus: userDa.data()['TaskStatus'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // ends of stateless widget
                      ),
                      onDismissed: (direction) async {
                        await authenticatedUser
                            .getTaskReference()
                            .doc(userDa.data()['id'])
                            .delete();
                      },
                    );
                  });
            } else {
              return Center(
                child: Text('NO TASKS LEFT YAY!!'),
              );
            }
          }
        });
  }
}

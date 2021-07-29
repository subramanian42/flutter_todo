import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:todolist_1/bussiness/authentication.dart';

class TaskManager extends StatefulWidget {
  TaskManager({Key? key}) : super(key: key);

  @override
  _TaskManagerState createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
/*   static CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users'); */
  CollectionReference taskRef = authUser.usersRef
      .doc(authUser.firebaseAuth.currentUser!.uid)
      .collection('Task');
  static Query<Map> query = authUser.usersRef
      .doc(authUser.firebaseAuth.currentUser!.uid)
      .collection('Task');
  //usersRef.doc(userid).collection('Task');
  DateTime? selectedDate = DateTime.now();

  final Stream<QuerySnapshot<Map<dynamic, dynamic>>> strm1 = query.snapshots();
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _taskcontroller = TextEditingController();

  @override
  void initState() {
    readTask();
    super.initState();
  }

  readTask() async {
    await query.get();
  }

  updateTask(docid) {
    taskRef.doc(docid).update({
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
      _datecontroller.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
    });
  }

  dialogbox(String docid, String TaskTitle, String duedate, String details) {
    _titlecontroller.text = TaskTitle;
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
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(authUser.firebaseAuth.currentUser!.uid)
                .collection('Task')
                .snapshots(),
            builder: (context, asyncsnap) {
              if (!asyncsnap.hasData) {
                return Center(child: Text('NO TASKS LEFT YAY!!'));
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: asyncsnap.data?.size,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Map<String, dynamic>> userDa =
                        asyncsnap.data!.docs[index];
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
                        child: Card(
                          elevation: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                      value:
                                          userDa.data()['TaskStatus'] ?? false,
                                      onChanged: (status) async {
                                        await taskRef
                                            .doc(userDa.data()['id'])
                                            .update({
                                          'TaskStatus': true,
                                        });
                                      }),
                                  Text(
                                    userDa.data()['TaskTitle'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: userDa.data()['TaskStatus']
                                            ? Colors.grey
                                            : Colors.black,
                                        decoration: userDa.data()['TaskStatus']
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                                  ),
                                  Text(
                                    userDa.data()['DueDate'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: userDa.data()['TaskStatus']
                                            ? Colors.grey
                                            : Colors.black,
                                        decoration: userDa.data()['TaskStatus']
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  userDa.data()['TaskDetails'],
                                  style: TextStyle(
                                      color: userDa.data()['TaskStatus']
                                          ? Colors.grey
                                          : Colors.black,
                                      decoration: userDa.data()['TaskStatus']
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (direction) async {
                        await taskRef.doc(userDa.data()['id']).delete();
                      },
                    );
                  });
            }),
      ],
    );
  }
}
/* ListTile(
                                title: Text(userDa.data()['TaskTitle']),
                                subtitle: Text(userDa.data()['TaskDetails']),
                              ); */

// ****************pervious function************* //

/* 
ListView.builder(
                    shrinkWrap: true,
                    itemCount: asyncsnap.data?.size,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Map<String, dynamic>> userDa =
                          asyncsnap.data!.docs[index];

                      return Dismissible(
                        key: UniqueKey(),
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Checkbox(
                                  value: userDa.data()['TaskStatus'],
                                  onChanged: (status) async {
                                    await taskRef
                                        .doc(userDa.data()['id'])
                                        .update({
                                      'TaskStatus': true,
                                    });
                                  }),
                              Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      userDa.data()['TaskTitle'],
                                      style: TextStyle(
                                          color: userDa.data()['TaskStatus']
                                              ? Colors.grey
                                              : Colors.black,
                                          decoration:
                                              userDa.data()['TaskStatus']
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      userDa.data()['TaskDetails'],
                                      style: TextStyle(
                                          color: userDa.data()['TaskStatus']
                                              ? Colors.grey
                                              : Colors.black,
                                          decoration:
                                              userDa.data()['TaskStatus']
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) async {
                          await taskRef.doc(userDa.data()['id']).delete();
                          /*  setState(() {
                            }); */
                        },
                      );
                    });
*/

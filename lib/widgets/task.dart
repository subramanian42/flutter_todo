import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Taskcard extends StatelessWidget {
  const Taskcard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.dueDate,
    required this.taskStatus,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String dueDate;
  final bool taskStatus;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: taskStatus ? Colors.grey : Colors.black,
                        decoration: taskStatus
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 2.0)),
                  Text(
                    subtitle,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: taskStatus ? Colors.grey : Colors.black,
                        decoration: taskStatus
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'DUE DATE:',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        dueDate,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: DateTime.now()
                                  .difference(
                                      DateFormat('d/M/y').parse(dueDate))
                                  .isNegative
                              ? Colors.black
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_project/Task.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TasksScreen extends StatefulWidget {
  int id;
  String name;
  TasksScreen(this.id, this.name);

  @override
  State<TasksScreen> createState() => Tasks(id, name);
}

class Tasks extends State<TasksScreen> {
  String name;
  int id;
  String dropdwonvalue = 'In Progress';
  String personvalue = 'Shaaban Shaheen';
  String category = 'Not found';
  String version = 'V1.0';
  String priority = 'High';
  String percent = '0.0';
  TextEditingController desc = TextEditingController();
  DateTime startdate = DateTime.now();
  DateTime endtdate = DateTime.now();
  DateTime hours = DateTime.now();
  TextEditingController newpercent = TextEditingController();
  List<Task> dataOfTask = [];

  Tasks(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id");

    http.get(uri).then((response) {
      var jsonResponse = jsonDecode(response.body);
      var embedded = jsonResponse['_embedded'];
      //var elements = embedded['elements'] as List;

      if (mounted) {
        setState(() {
          /*Iterable<Task> subjects = elements
              .map((data) => Task(id: data['id'], task: data['subject']));
          dataOfTask = subjects.toList();*/
        });
      }
    });

    return Scaffold(
        appBar: AppBar(
            title: const Row(
          children: [
            Text(
              "Type",
              style: TextStyle(fontSize: 15.0),
            ),
            SizedBox(width: 15, height: 3),
            Text("Name of Task", style: TextStyle(fontSize: 19.0))
          ],
        )),
        body: SingleChildScrollView(
          child: Column(children: [
            //Start part 1
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: dropdwonvalue,
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 3,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdwonvalue = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'In Progress',
                      child: Text('In Progress'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Two',
                      child: Text('Two'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Three',
                      child: Text('Three'),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 33, height: 3),
              Column(children: [
                const Row(children: [
                  Text("Create by:"),
                  SizedBox(width: 8, height: 3),
                  Text("Shaaban Shaheen"),
                ]),
                Row(children: [
                  const Text("Last updates:"),
                  const SizedBox(width: 8, height: 3),
                  Text(
                      "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} "),
                  Text("${DateTime.now().hour}:${DateTime.now().minute} ")
                ]),
              ]),
            ]),
            //End part1
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: desc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
                ),
              ),
            ),
            //Start part 3
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "People:",
                      style: TextStyle(
                          fontSize: 20.0, fontStyle: FontStyle.italic),
                    ),
                    Row(children: [
                      const Text("Assignee:"),
                      const SizedBox(width: 28, height: 0),
                      DropdownButton<String>(
                        value: personvalue,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            personvalue = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Shaaban Shaheen',
                            child: Text('Shaaban Shaheen'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Yaman Kalaji',
                            child: Text('Yaman Kalaji'),
                          ),
                        ],
                      ),
                    ]),
                    Row(children: [
                      const Text("Accountable:"),
                      const SizedBox(width: 8, height: 0),
                      DropdownButton<String>(
                        value: personvalue,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            personvalue = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Shaaban Shaheen',
                            child: Text('Shaaban Shaheen'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Yaman Kalaji',
                            child: Text('Yaman Kalaji'),
                          )
                        ],
                      ),
                    ]),
                  ]),
            ),
            //End part3
            //Start part4
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimates & Time:',
                        style: TextStyle(
                            fontSize: 20.0, fontStyle: FontStyle.italic)),
                    Row(children: [
                      const Text('Estimated time:'),
                      CupertinoButton(
                          child: Text('${hours.hour}'),
                          onPressed: () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => SizedBox(
                                      height: 250,
                                      child: CupertinoDatePicker(
                                        backgroundColor: Colors.white,
                                        initialDateTime: hours,
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.time,
                                        onDateTimeChanged: (DateTime value) {
                                          setState(() {
                                            hours = value;
                                          });
                                        },
                                      ),
                                    ));
                          }),
                      const Text('h')
                    ]),
                  ]),
            ),
            //End part4
            //Start part5
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Detail:',
                        style: TextStyle(
                            fontSize: 20.0, fontStyle: FontStyle.italic)),
                    Row(children: [
                      const Text('Date:'),
                      TextButton(
                        child: Text(
                            '${startdate.year} / ${startdate.month} / ${startdate.day}'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null && startdate.isBefore(value)) {
                              setState(() {
                                startdate = value;
                              });
                            }
                          });
                        },
                      ),
                      TextButton(
                        child: Text(
                            '${endtdate.year} / ${endtdate.month} / ${endtdate.day}'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null && endtdate.isBefore(value)) {
                              setState(() {
                                endtdate = value;
                              });
                            }
                          });
                        },
                      )
                    ]),
                    Row(children: [
                      const Text("Progress%:"),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: LinearPercentIndicator(
                          width: 100.0,
                          animation: true,
                          animationDuration: 1000,
                          animateFromLastPercent: true,
                          lineHeight: 20.0,
                          percent: double.parse(percent) / 100.0,
                          center: Text('${double.parse(percent)}%'),
                          barRadius: const Radius.circular(16),
                          progressColor: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text("Enter percent"),
                                    content: TextField(
                                      autofocus: true,
                                      controller: newpercent,
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter value'),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (newpercent.text.isNotEmpty) {
                                                Navigator.of(context)
                                                    .pop(newpercent.text);
                                                percent = newpercent.text;
                                                newpercent.clear();
                                              } else {
                                                return;
                                              }
                                            });
                                          },
                                          child: const Text("OK"))
                                    ],
                                  ));
                        },
                        icon: const Icon(ModernPictograms.pencil),
                        color: Colors.blue,
                      ),
                    ]),
                    Row(children: [
                      const Text("Category:"),
                      const SizedBox(width: 5.0),
                      DropdownButton<String>(
                        value: category,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            category = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Not found',
                            child: Text('Not found'),
                          )
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      const Text("Version:"),
                      const SizedBox(width: 5.0),
                      DropdownButton<String>(
                        value: version,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            version = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'V1.0',
                            child: Text('V1.0'),
                          )
                        ],
                      ),
                    ]),
                    Row(children: [
                      const Text("Priority:"),
                      const SizedBox(width: 5.0),
                      DropdownButton<String>(
                        value: priority,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            priority = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'High',
                            child: Text('High'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Low',
                            child: Text('Low'),
                          )
                        ],
                      ),
                    ]),
                  ]),
            ),

            //End part5
          ]),
        ));
  }
}

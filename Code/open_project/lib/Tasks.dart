import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_project/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TasksScreen extends StatefulWidget {
  int id;
  String nameOfTask;
  TasksScreen(this.id, this.nameOfTask);

  @override
  State<TasksScreen> createState() => Tasks(id, nameOfTask);
}

class Tasks extends State<TasksScreen> {
  String nameOfTask;
  int id;
  String dropdwonvalue = 'In Progress';
  String personvalue = 'Shaaban Shahin';
  String category = 'Not found';

  TextEditingController desc = TextEditingController();
  DateTime startdate = DateTime.now();
  DateTime endtdate = DateTime.now();
  DateTime hours = DateTime.now();
  TextEditingController newpercent = TextEditingController();
  var embedded,
      subject = 'Not found',
      startDate = 'Not found',
      dueDate = 'Not found',
      estimatedTime = 'Not found',
      percentageDone = 0,
      updatedAt = 'Not changed';
  var rawOfdescription = 'Not found',
      nameOfType = 'Not type',
      nameOfPriority = 'Not found',
      nameOfStatus = 'Not found',
      nameOfAuthor = 'No person',
      nameOfAssignee = 'No person',
      nameOfVersion = 'No version',
      color = '#000000',
      lockVersion = 0;

  String taskBody = """{
  "_type": "WorkPackage",
    "id": 38,
    "lockVersion": 5,
    "subject": "Final wireframe 4",
    "description": {
        "format": "markdown",
        "raw": "",
        "html": ""
    },
    "scheduleManually": false,
    "startDate": null,
    "dueDate": null,
    "estimatedTime": null,
    "derivedEstimatedTime": null,
    "duration": null,
    "ignoreNonWorkingDays": false,
    "percentageDone": 0,
    "remainingTime": null,
    "derivedRemainingTime": null
  
}""";
  Tasks(this.id, this.nameOfTask);

  void getTask() async {
    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id");
    await http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        subject = jsonResponse['subject'];
        lockVersion = jsonResponse['lockVersion'];
        if (jsonResponse['estimatedTime'] != null) {
          estimatedTime = jsonResponse['estimatedTime'];
        }
        if (jsonResponse['startDate'] != null) {
          startDate = jsonResponse['startDate'];
        }
        if (jsonResponse['dueDate'] != null) {
          dueDate = jsonResponse['dueDate'];
        }
        if (jsonResponse['updatedAt'] != null) {
          updatedAt = jsonResponse['updatedAt'];
        }
        if (jsonResponse['percentageDone'] != 0) {
          percentageDone = jsonResponse['percentageDone'];
        }

        embedded = jsonResponse['_embedded'];
        //Type
        var type = embedded['type'];
        nameOfType = type['name'];
        color = type['color'];
        //Color typeColor = Color.fromHex('#aabbcc');
        //Priority
        embedded = jsonResponse['_embedded'];
        var priority = embedded['priority'];
        nameOfPriority = priority['name'];
        //Status
        var status = embedded['status'];
        nameOfStatus = status['name'];
        //CreatedBy
        var author = embedded['author'];
        nameOfAuthor = author['name'];
        //Assignee
        var assignee = embedded['assignee'];
        nameOfAssignee = assignee['name'];
        //Version
        if (embedded['version'] != null) {
          var version = embedded['version'];
          nameOfVersion = version['name'];
        }
        //Decription
        var description = embedded['project'];
        var desc = description['description'];
        if (desc['raw'] != null) {
          rawOfdescription = desc['raw'];
        }

        if (mounted) {
          setState(() {});
        }
      } else {
        print('Failed');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: Row(
              children: [
                Text(
                  nameOfType.toString(),
                  style: const TextStyle(fontSize: 13.0),
                  /*selectionColor: Color(int.parse(color.toString())),*/
                ),
                const SizedBox(width: 15),
                Text(subject.toString(), style: const TextStyle(fontSize: 13.0))
              ],
            )),
        body: SingleChildScrollView(
          child: Column(children: [
            //Start part 1
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: nameOfStatus.toString(),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 3,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      nameOfStatus = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: nameOfStatus.toString(),
                      child: Text(nameOfStatus.toString()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8, height: 3),
              Column(children: [
                Row(children: [
                  Text("Create by:"),
                  SizedBox(width: 5, height: 3),
                  Text(nameOfAuthor.toString()),
                ]),
                Row(children: [
                  const Text("Last updates:"),
                  const SizedBox(width: 5, height: 3),
                  Text(updatedAt.toString()),
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
                decoration: InputDecoration(
                  labelText: rawOfdescription,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    //value = rawOfdescription.toString();
                    desc.text = rawOfdescription.toString();
                    value = desc.text;
                  });
                },
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
                        value: nameOfAssignee.toString(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            nameOfAssignee = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: nameOfAssignee.toString(),
                            child: Text(nameOfAssignee.toString()),
                          )
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
                      const Text('Estimated time:  '),
                      Text(estimatedTime.toString()),
                      /*CupertinoButton(
                          child: Text(estimatedTime.toString()),
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
                                            estimatedTime = value.toString();
                                          });
                                        },
                                      ),
                                    ));
                          }),*/
                      const Text('  h')
                    ]),
                  ]),
            ),
            //End part4
            //Start part5
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Detail:',
                        style: TextStyle(
                            fontSize: 20.0, fontStyle: FontStyle.italic)),
                    Row(children: [
                      const Text('Date:'),
                      TextButton(
                        child: Text(startDate.toString()),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value !=
                                null /*&& startdate.isBefore(value)*/) {
                              setState(() {
                                startdate = value;
                              });
                            }
                          });
                        },
                      ),
                      TextButton(
                        child: Text(dueDate.toString()),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null /*&& endtdate.isBefore(value)*/) {
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
                          percent:
                              double.parse(percentageDone.toString()) / 100.0,
                          center: Text(
                              '${double.parse(percentageDone.toString())}'),
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
                                                //percent = newpercent.text;
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
                        value: nameOfVersion.toString(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            nameOfVersion = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: nameOfVersion.toString(),
                            child: Text(nameOfVersion.toString()),
                          )
                        ],
                      ),
                    ]),
                    Row(children: [
                      const Text("Priority:"),
                      const SizedBox(width: 5.0),
                      DropdownButton<String>(
                        value: nameOfPriority.toString(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            nameOfPriority = newValue!;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            value: nameOfPriority.toString(),
                            child: Text(nameOfPriority.toString()),
                          ),
                        ],
                      ),
                    ]),
                  ]),
            ),
            //End part5
            ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: lockVersion.toString());

                setState(() {});
              },
              style: button(),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ]),
        ));
  }
}

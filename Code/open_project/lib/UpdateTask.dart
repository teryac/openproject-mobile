// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_project/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;

class UpdateScreen extends StatefulWidget {
  int id;
  String name;

  UpdateScreen(this.id, this.name);

  @override
  State<UpdateScreen> createState() => UpdateTask(id, name);
}

class UpdateTask extends State<UpdateScreen> {
  int id;
  //String percentageDone = '0.0';
  String name;
  String progressValue = 'In progress';
  String personvalue = 'Shaaban Shahin';
  String assignee = 'Shaaban Shahin';
  String accountable = 'Shaaban Shahin';
  String category = 'Not found';
  String version = 'V 1.0';
  String priority = 'High';
  String type = 'Task';

  TextEditingController desc = TextEditingController();
  TextEditingController percent = TextEditingController();
  TextEditingController task = TextEditingController();
  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();
  DateTime hours = DateTime.now();
  DateTime updateTime = DateTime.now();

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

  UpdateTask(this.id, this.name);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(name, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: task,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: subject.toString(),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        //task.text = subject.toString();
                        value = task.text;
                        print(value);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: type,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 3,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      type = nameOfType;
                      setState(() {
                        nameOfType = newValue!;
                        print(newValue);
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Task',
                        child: Text('Task'),
                      ),
                      DropdownMenuItem(
                        value: 'Milestone',
                        child: Text('Milestone'),
                      ),
                      DropdownMenuItem(
                        value: 'Phase',
                        child: Text('Phase'),
                      ),
                      DropdownMenuItem(
                        value: 'User story',
                        child: Text('User story'),
                      ),
                      DropdownMenuItem(
                        value: 'Bug',
                        child: Text('Bug'),
                      ),
                      DropdownMenuItem(
                        value: 'Epic',
                        child: Text('Epic'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: progressValue,
                  icon: const Icon(Icons.arrow_drop_down),
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 3,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    progressValue = nameOfStatus;
                    setState(() {
                      nameOfStatus = newValue!;
                      print(newValue);
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'In progress',
                      child: Text('In progress'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'New',
                      child: Text('New'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'In Specification',
                      child: Text('In Specification'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Specified',
                      child: Text('Specified'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Developed',
                      child: Text('Developed'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'In testing',
                      child: Text('In testing'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Tested',
                      child: Text('Tested'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Test failed',
                      child: Text('Test failed'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Closed',
                      child: Text('Closed'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'On hold',
                      child: Text('On hold'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Reject',
                      child: Text('Reject'),
                    ),
                  ],
                ),
              ),
              Column(children: [
                Row(children: [
                  Text("Create by:"),
                  SizedBox(width: 5, height: 3),
                  DropdownButton<String>(
                    value: personvalue,
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 3,
                      color: Colors.black,
                    ),
                    onChanged: (String? newValue) {
                      personvalue = nameOfAssignee;
                      setState(() {
                        nameOfAssignee = newValue!;
                        print(newValue);
                      });
                    },
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Shaaban Shahin',
                        child: Text('Shaaban Shahin'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Yaman Kalaji',
                        child: Text('Yaman Kalaji'),
                      ),
                    ],
                  ),
                ]),
                Row(children: [
                  const Text("Last updates:"),
                  const SizedBox(width: 5, height: 3),
                  Text(
                      '${updateTime.year} / ${updateTime.month} / ${updateTime.day}'),
                ]),
              ]),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: desc,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: rawOfdescription.toString(),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    value = desc.text;
                    print(value);
                  });
                },
              ),
            ),
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
                        value: assignee,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          assignee = nameOfAssignee;
                          setState(() {
                            nameOfAssignee = newValue!;
                            print(newValue);
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Shaaban Shahin',
                            child: Text('Shaaban Shahin'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Yaman Kalaji',
                            child: Text('Yaman Kalaji'),
                          )
                        ],
                      ),
                    ]),
                    Row(children: [
                      const Text("Accountable:"),
                      const SizedBox(width: 8, height: 0),
                      DropdownButton<String>(
                        value: accountable,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 3,
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            accountable = newValue!;
                            print(newValue);
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Shaaban Shahin',
                            child: Text('Shaaban Shahin'),
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
                          child: Text(estimatedTime),
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
                                            estimatedTime =
                                                value.hour.toString();
                                            print(estimatedTime);
                                          });
                                        },
                                      ),
                                    ));
                          }),
                      const Text('h')
                    ]),
                  ]),
            ),
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
                        child: Text(startDate),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                startDate =
                                    '${value.year} / ${value.month} / ${value.day}';
                                print(startDate);
                              });
                            }
                          });
                        },
                      ),
                      TextButton(
                        child: Text(dueDate),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                dueDate =
                                    '${value.year} / ${value.month} / ${value.day}';
                                print(dueDate);
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
                                      controller: percent,
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter value'),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              if (percent.text.isNotEmpty) {
                                                Navigator.of(context)
                                                    .pop(percent.text);
                                                percentageDone =
                                                    int.parse(percent.text);
                                                print(percentageDone);
                                                percent.clear();
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
                          version = nameOfVersion;
                          setState(() {
                            nameOfVersion = newValue!;
                            print(newValue);
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'V 1.0',
                            child: Text('V 1.0'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Bug Backlog',
                            child: Text('Bug Backlog'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Product Backlog',
                            child: Text('Product Backlog'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Sprint 1',
                            child: Text('Sprint 1'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Sprint 2',
                            child: Text('Sprint 2'),
                          ),
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
                          priority = nameOfPriority;
                          setState(() {
                            nameOfPriority = newValue!;
                            print(newValue);
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Low',
                            child: Text('Low'),
                          ),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: 'Normal',
                            child: Text('Normal'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Immediate',
                            child: Text('Immmediate'),
                          ),
                          DropdownMenuItem(
                            value: 'High',
                            child: Text('High'),
                          ),
                        ],
                      ),
                    ]),
                  ]),
            ),
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
          ],
        ),
      ),
    );
  }
}

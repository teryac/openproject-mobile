// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:open_project/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:easy_date_timeline/easy_date_timeline.dart';

class AddScreen extends StatefulWidget {
  int id;
  String name;

  AddScreen(this.id, this.name);

  @override
  State<AddScreen> createState() => AddTask(id, name);
}

class AddTask extends State<AddScreen> {
  int id;
  String percentageDone = '0.0';
  String name;
  String progressValue = 'In Progress';
  String personvalue = 'Shaaban Shaheen';
  String assignee = 'Shaaban Shaheen';
  String accountable = 'Shaaban Shaheen';
  String category = 'Not found';
  String version = 'V 1.0';
  String priority = 'High';
  String type = 'Task';

  TextEditingController desc = TextEditingController();
  TextEditingController percent = TextEditingController();
  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();
  DateTime hours = DateTime.now();
  DateTime updateTime = DateTime.now();

  AddTask(this.id, this.name);

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
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Task",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: desc,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Name of task',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              desc.text = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                        width:
                            10), // Add spacing between TextField and DropdownButton
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[
                            200], // Background color for the DropdownButton
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      padding: const EdgeInsets.only(left: 3), // Inner padding
                      child: DropdownButton<String>(
                        dropdownColor: Colors.blue[200],
                        iconEnabledColor: Colors.white,
                        value: type,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (String? newValue) {
                          setState(() {
                            type = newValue!;
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
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                EasyDateTimeLine(
                  initialDate: DateTime.now(),
                  onDateChange: (selectedDate) {
                    //[selectedDate] the new date selected.
                  },
                  activeColor: const Color(0xff85A389),
                  dayProps: const EasyDayProps(
                    todayHighlightStyle: TodayHighlightStyle.withBackground,
                    todayHighlightColor: Color(0xffE1ECC8),
                  ),
                ),
              ],
            ),
            /*Row(children: [
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
                    setState(() {
                      progressValue = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'In Progress',
                      child: Text('In Progress'),
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
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    desc.text = value;
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
                          setState(() {
                            assignee = newValue!;
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
                            '${enddate.year} / ${enddate.month} / ${enddate.day}'),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2030))
                              .then((value) {
                            if (value != null && enddate.isBefore(value)) {
                              setState(() {
                                enddate = value;
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
                                                percentageDone = percent.text;
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
                          setState(() {
                            version = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'V 1.0',
                            child: Text('V 1.0'),
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
                          DropdownMenuItem(
                            value: 'Low',
                            child: Text('Low'),
                          ),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
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
                //Fluttertoast.showToast(msg: lockVersion.toString());

                setState(() {});
              },
              style: button(),
              child: const Text(
                'Add',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

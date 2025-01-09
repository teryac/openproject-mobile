// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:open_project/DetailOfProject.dart';
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
  String personvalue = 'Shaaban Shahin';
  String assignee = 'Shaaban Shahin';
  String accountable = 'Shaaban Shahin';
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
  var initialDate;
  var selectedYear;

  AddTask(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => StateDetail(id, name)));
            setState(() {});
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Row 1
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Task
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Task:",
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
                    const SizedBox(width: 5),
                    SizedBox(
                      height: 63, // Match this height with the TextField height
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.blueAccent,
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
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 5.0),
              ],
            ),
            //Status
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Status:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 22.0),
                SizedBox(
                  height: 25.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.only(left: 8),
                    child: DropdownButton<String>(
                      value: progressValue,
                      dropdownColor: Colors.blueAccent,
                      iconEnabledColor: Colors.white,
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: Colors.white),
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
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            //Create by
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Create by:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Shaaban Shahin",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            //Update at
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Update at:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  '${updateTime.year} / ${updateTime.month} / ${updateTime.day}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            //Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Description:",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: TextField(
                    controller: desc,
                    keyboardType: TextInputType.name,
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
              ],
            ),
            const SizedBox(height: 5.0),
            //Assignee & Accountable
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "People:",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Row(children: [
                      const Text("Assignee:"),
                      const SizedBox(width: 28, height: 0),
                      SizedBox(
                        height: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            value: assignee,
                            dropdownColor: Colors.blueAccent,
                            iconEnabledColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                assignee = newValue!;
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
                        ),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      const Text("Accountable:"),
                      const SizedBox(width: 8, height: 0),
                      SizedBox(
                        height: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            value: accountable,
                            dropdownColor: Colors.blueAccent,
                            iconEnabledColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String? newValue) {
                              setState(() {
                                accountable = newValue!;
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
                        ),
                      ),
                    ]),
                  ]),
            ),
            // Estimates & Time
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimates & Time:',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                    Row(children: [
                      const Text('Estimated time:'),
                      CupertinoButton(
                        child: Text(
                            'Day: ${hours.day}  Hour: ${hours.hour}  Minutes: ${hours.minute}'),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: 250,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.white,
                                initialDateTime: hours,
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                onDateTimeChanged: (DateTime value) {
                                  setState(() {
                                    hours = value;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
                  ]),
            ),
            //Detail
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail:',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    //Start Date && Due Date
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Date:'),
                          /*CupertinoButton(
                            child: Text("Select Year"),
                            onPressed: () async {
                              selectedYear = await showCupertinoModalPopup<int>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 250,
                                    color: Colors.white,
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: DateTime.now().year -
                                            2000, // Adjust as needed
                                      ),
                                      itemExtent: 40,
                                      onSelectedItemChanged: (int index) {
                                        Navigator.pop(
                                            context,
                                            2000 +
                                                index); // Return the selected year
                                      },
                                      children: List<Widget>.generate(
                                        100, // Years range from 2000 to 2099
                                        (index) => Center(
                                          child: Text('${2000 + index}'),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              if (selectedYear != null) {
                                // Update your timeline with the selected year.
                                setState(() {
                                  initialDate = DateTime(selectedYear,
                                      DateTime(1900).month, DateTime(1900).day);
                                });
                              }
                            },
                          ),*/
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              // Handle the new selected date, including the year.
                            },
                            activeColor: const Color(0xff85A389),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              todayHighlightColor: Color(0xffE1ECC8),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Text('Due Date:'),
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              //[selectedDate] the new date selected.
                            },
                            activeColor: const Color(0xff85A389),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              todayHighlightColor: Color(0xffE1ECC8),
                            ),
                          ),
                        ]),
                    //Progress
                    Row(children: [
                      const Text(
                        "Progress%:",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      LinearPercentIndicator(
                        width: 100.0,
                        animation: true,
                        animationDuration: 1000,
                        animateFromLastPercent: true,
                        lineHeight: 20.0,
                        percent:
                            double.parse(percentageDone.toString()) / 100.0,
                        center:
                            Text('${double.parse(percentageDone.toString())}'),
                        barRadius: const Radius.circular(16),
                        progressColor: Colors.blue,
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
                    const SizedBox(height: 3.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //category
                          Row(
                            children: [
                              const Text(
                                "Category:",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 10.0),
                              SizedBox(
                                height: 25.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButton<String>(
                                    value: category,
                                    dropdownColor: Colors.blueAccent,
                                    iconEnabledColor: Colors.white,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        category = newValue!;
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'Not found',
                                        child: Text('Not found'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          //version
                          Row(
                            children: [
                              const Text(
                                "Version:",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 50.0),
                              SizedBox(
                                height: 25.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButton<String>(
                                    value: version,
                                    dropdownColor: Colors.blueAccent,
                                    iconEnabledColor: Colors.white,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        version = newValue!;
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem<String>(
                                        value: 'V 1.0',
                                        child: Text('V 1.0'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 15.0),
                    //Priority
                    Row(children: [
                      const Text(
                        "Priority:",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 32.0),
                      SizedBox(
                        height: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            value: priority,
                            dropdownColor: Colors.blueAccent,
                            iconEnabledColor: Colors.white,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(color: Colors.white),
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
                        ),
                      ),
                      /*DropdownButton<String>(
                        value: priority,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(color: Colors.black),
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
                      ),*/
                    ]),
                  ]),
            ),
            const SizedBox(height: 25.0),
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
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}

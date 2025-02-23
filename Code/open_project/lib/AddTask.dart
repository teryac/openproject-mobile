import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:http/http.dart';
import 'package:open_project/DetailOfProject.dart';
import 'package:open_project/Property.dart';
import 'package:open_project/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<Property> listOfStatus = [
    /*'In progress',
    'New',
    'In Specification',
    'Specified',
    'Developed',
    'In testing',
    'Tested',
    'Test failed',
    'Closed',
    'On hold',
    'Reject',*/
  ];

  List<Property> listOfType = [
    /*'Task',
    'Milestone',
    'Phase',
    'User story',
    'Bug',
    'Epic',*/
  ];

  List<Property> listOfPriority = [
    /* 'Low',
    'Medium',
    'Normal',
    'Immediate',
    'High',*/
  ];

  List<Property> listOfVersion = [
    /*'V 1.0',
    'Bug Backlog',
    'Product Backlog',
    'Sprit 1',
    'Sprit 2',*/
  ];

  List<Property> listOfUser = [];

  List<Property> listOfCategory = [];

  Property? selectedStatus;
  Property? selectedType;
  Property? selectedPriority;
  Property? selectedUser;
  Property? selectedVersion;
  Property? selectedCategory;
  String? apikey;
  String? token;

  AddTask(this.id, this.name);

  void getAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';
    //Categories
    Response rCategories = await get(
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/categories"),
        headers: <String, String>{'authorization': basicAuth});
    if (rCategories.statusCode == 200) {
      var jsonResponse = jsonDecode(rCategories.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Property> property = elements.map((data) {
          String pro = data['name'];

          int idCategory = data['id'];

          return Property(id: idCategory, name: pro);
        }).toList();
        setState(() {
          listOfCategory = property;
        });
      }
    }
    //Priorities
    Response rPriorities = await get(
        Uri.parse("https://op.yaman-ka.com/api/v3/priorities"),
        headers: <String, String>{'authorization': basicAuth});
    if (rPriorities.statusCode == 200) {
      var jsonResponse = jsonDecode(rPriorities.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Property> property = elements.map((data) {
          String pro = data['name'];

          int idProperty = data['id'];

          return Property(id: idProperty, name: pro);
        }).toList();
        setState(() {
          listOfPriority = property;
        });
      }
    }
    //Types
    Response rTypes = await get(
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/types"),
        headers: <String, String>{'authorization': basicAuth});
    if (rTypes.statusCode == 200) {
      var jsonResponse = jsonDecode(rTypes.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Property> property = elements.map((data) {
          String pro = data['name'];

          int idType = data['id'];

          return Property(id: idType, name: pro);
        }).toList();
        setState(() {
          listOfType = property;
        });
      }
    }
    //Users
    Response rUsers = await get(
        Uri.parse(
            "https://op.yaman-ka.com/api/v3/projects/$id/available_assignees"),
        headers: <String, String>{'authorization': basicAuth});
    if (rUsers.statusCode == 200) {
      var jsonResponse = jsonDecode(rUsers.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Property> property = elements.map((data) {
          String pro = data['name'];

          int idUser = data['id'];

          return Property(id: idUser, name: pro);
        }).toList();
        setState(() {
          listOfUser = property;
        });
      }
    }

    //Versions
    Response rVersion = await get(
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/versions"),
        headers: <String, String>{'authorization': basicAuth});
    if (rVersion.statusCode == 200) {
      var jsonResponse = jsonDecode(rVersion.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Property> property = elements.map((data) {
          String pro = data['name'];

          int idVersion = data['id'];

          return Property(id: idVersion, name: pro);
        }).toList();
        setState(() {
          listOfVersion = property;
        });
      }
    }
    //Status
    Response rStatus = await get(
        Uri.parse("https://op.yaman-ka.com/api/v3/statuses"),
        headers: <String, String>{'authorization': basicAuth});
    if (rStatus.statusCode == 200) {
      var jsonResponse = jsonDecode(rStatus.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Property> property = elements.map((data) {
          String pro = data['name'];

          int idStatus = data['id'];

          return Property(id: idStatus, name: pro);
        }).toList();
        setState(() {
          listOfStatus = property;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

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
                          keyboardType: TextInputType.multiline,
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(left: 3),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<Property>(
                            isExpanded: true,
                            hint: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select Type',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff2595AF),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: listOfType
                                .map((Property item) =>
                                    DropdownMenuItem<Property>(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff2595AF),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedType,
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 60,
                              width: 120,
                              padding: const EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                                color: const Color(0xffE1F2F6),
                              ),
                              elevation: 0,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 20,
                              iconEnabledColor: Color(0xff2595AF),
                              iconDisabledColor: Color(0xff2595AF),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color(0xffE1F2F6),
                              ),
                              //offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(6),
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                          ),
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
                const SizedBox(width: 15.0),
                SizedBox(
                  height: 25.0,
                  child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.only(left: 8),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<Property>(
                        isExpanded: true,
                        hint: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Select Status',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: listOfStatus
                            .map((Property item) => DropdownMenuItem<Property>(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: selectedStatus,
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 150,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: const Color(0xff69B73F),
                          ),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          iconSize: 20,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 130,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color(0xff69B73F),
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 30,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Property>(
                              isExpanded: true,
                              hint: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Select Assignee',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2595AF),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: listOfUser
                                  .map((Property item) =>
                                      DropdownMenuItem<Property>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff2595AF),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: selectedUser,
                              onChanged: (value) {
                                setState(() {
                                  selectedUser = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 60,
                                width: 150,
                                padding: const EdgeInsets.only(left: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: const Color(0xffE1F2F6),
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 20,
                                iconEnabledColor: Color(0xff2595AF),
                                iconDisabledColor: Color(0xff2595AF),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 120,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xffE1F2F6),
                                ),
                                //offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: MaterialStateProperty.all(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Property>(
                              isExpanded: true,
                              hint: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Select Accountable',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2595AF),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: listOfUser
                                  .map((Property item) =>
                                      DropdownMenuItem<Property>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff2595AF),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: selectedUser,
                              onChanged: (value) {
                                setState(() {
                                  selectedUser = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 60,
                                width: 170,
                                padding: const EdgeInsets.only(left: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: const Color(0xffE1F2F6),
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 20,
                                iconEnabledColor: Color(0xff2595AF),
                                iconDisabledColor: Color(0xff2595AF),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 120,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xffE1F2F6),
                                ),
                                //offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: MaterialStateProperty.all(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
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
                            activeColor: const Color(0xff2595AF),
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
                            activeColor: const Color(0xff2595AF),
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
                              const SizedBox(width: 30),
                              SizedBox(
                                height: 25.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<Property>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Select Category',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff2595AF),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: listOfCategory
                                          .map((Property item) =>
                                              DropdownMenuItem<Property>(
                                                value: item,
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff2595AF),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedCategory,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 60,
                                        width: 150,
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: const Color(0xffE1F2F6),
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        iconSize: 20,
                                        iconEnabledColor: Color(0xff2595AF),
                                        iconDisabledColor: Color(0xff2595AF),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 120,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: const Color(0xffE1F2F6),
                                        ),
                                        //offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              MaterialStateProperty.all(6),
                                          thumbVisibility:
                                              MaterialStateProperty.all(true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<Property>(
                                      isExpanded: true,
                                      hint: const Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Select version',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff2595AF),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: listOfVersion
                                          .map((Property item) =>
                                              DropdownMenuItem<Property>(
                                                value: item,
                                                child: Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff2595AF),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedVersion,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedVersion = value;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 60,
                                        width: 140,
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: const Color(0xffE1F2F6),
                                        ),
                                        elevation: 0,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        iconSize: 20,
                                        iconEnabledColor: Color(0xff2595AF),
                                        iconDisabledColor: Color(0xff2595AF),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 120,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          color: const Color(0xffE1F2F6),
                                        ),
                                        //offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              MaterialStateProperty.all(6),
                                          thumbVisibility:
                                              MaterialStateProperty.all(true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
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
                      const SizedBox(width: 50),
                      SizedBox(
                        height: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Property>(
                              isExpanded: true,
                              hint: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Select Priority',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2595AF),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: listOfPriority
                                  .map((Property item) =>
                                      DropdownMenuItem<Property>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff2595AF),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: selectedPriority,
                              onChanged: (value) {
                                setState(() {
                                  selectedPriority = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 60,
                                width: 140,
                                padding: const EdgeInsets.only(left: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  color: const Color(0xffE1F2F6),
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 20,
                                iconEnabledColor: Color(0xff2595AF),
                                iconDisabledColor: Color(0xff2595AF),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 120,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xffE1F2F6),
                                ),
                                //offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: MaterialStateProperty.all(6),
                                  thumbVisibility:
                                      MaterialStateProperty.all(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
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
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:open_project/work_packages/DetailOfProject.dart';
import 'package:open_project/GetStart.dart';
import 'package:open_project/Property.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddScreen extends StatefulWidget {
  int id;
  String name;

  AddScreen(this.id, this.name, {super.key});

  @override
  State<AddScreen> createState() => AddTask(id, name);
}

class AddTask extends State<AddScreen> {
  int id;
  String percentageDone = '0.0';
  String name;
  String status = "New";
  int idStatus = 1;
  String? task;
  String? assignee;
  int? idAssignee;
  int? idAccountable;
  String? accountable;
  var category;
  int? idCategory;
  var version;
  int? idVersion;
  String priority = 'Normal';
  int idPriority = 8;
  String type = "Task";
  int idType = 1;
  String? description;
  int hour = 0, minutes = 0;
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  TextEditingController desc = TextEditingController();
  TextEditingController nameOfTask = TextEditingController();
  TextEditingController percent = TextEditingController();
  var startdate, urlCategory, urlVersion, color;
  var duedate;
  DateTime? hours, sDate, dDate;
  DateTime updateTime = DateTime.now();

  List<Property> listOfStatus = [];
  List<Property> listOfType = [];
  List<Property> listOfPriority = [];
  List<Property> listOfVersion = [];
  List<Property> listOfUser = [];
  List<Property> listOfCategory = [];

  Property? selectedStatus;
  Property? selectedType;
  Property? selectedPriority;
  Property? selectedAssignee;
  Property? selectedAccountable;
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
          color = data['color'];
          int idCategory = data['id'];

          return Property(id: idCategory, name: pro, color: color);
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
          color = data['color'];
          int idProperty = data['id'];

          return Property(id: idProperty, name: pro, color: color);
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
          color = data['color'];
          int idType = data['id'];

          return Property(id: idType, name: pro, color: color);
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
          color = data['color'];
          int idUser = data['id'];

          return Property(id: idUser, name: pro, color: color);
        }).toList();
        if (mounted) {
          setState(() {
            listOfUser = property;
          });
        }
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
          color = data['color'];
          int idVersion = data['id'];

          return Property(id: idVersion, name: pro, color: color);
        }).toList();
        if (mounted) {
          setState(() {
            listOfVersion = property;
          });
        }
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
          color = data['color'];
          int idStatus = data['id'];

          return Property(id: idStatus, name: pro, color: color);
        }).toList();
        if (mounted) {
          setState(() {
            listOfStatus = property;
          });
        }
      }
    }
  }

  void addTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';
    String newTask = """{\n    
    "_type": "WorkPackage",\n    
    "subject": "$task",\n    
    "description": {\n        
    "format": "markdown",\n        
    "raw": "$description" \n    },\n   
     "priority": {\n        
     "href": "/api/v3/priorities/$idPriority",\n       
      "title": "$priority"\n    },\n    
      "status": {\n        
      "href": "/api/v3/statuses/$idStatus",\n        
      "title": "$status"\n    },\n    
      "type": {\n        
      "href": "/api/v3/types/$idType",\n        
      "title": "$type"\n    },\n    
      "assignee": {\n        
      "href": "/api/v3/users/$idAssignee",\n        
      "title": "$assignee"\n    },\n    
      "responsible": {\n        
      "href": "/api/v3/users/$idAccountable",\n        
      "title": "$accountable"\n    },\n    
      "project": {\n        
      "href": "/api/v3/projects/$id",\n        
      "title": "$name"\n    },\n    
      "version": {\n        
      "href": $urlVersion,\n        
      "title": $version\n    },\n    
      "category": {\n        
      "href": $urlCategory,\n        
      "title": $category\n},\n  
      "startDate": $startdate,\n    
      "dueDate": $duedate,\n    
      "estimatedTime": "PT${hour}H${minutes}M",\n    
      "customField1": "Custom Value",\n    
      "customField2": 123,\n    
      "percentageDone": "$percentageDone"\n}""";
    print(newTask);
    await http.post(
      Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/work_packages"),
      body: newTask,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Task has been added');
      } else {
        Fluttertoast.showToast(msg: 'You cannot add task');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
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
            //Task & Type
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
                          controller: nameOfTask,
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
                              task = value.isNotEmpty
                                  ? value
                                  : "Enter name of task";
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
                                    "Select type",
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
                                type = value!.name;
                                idType = value.id;
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
                                elevation: 0),
                            iconStyleData: const IconStyleData(
                              icon: Icon(Icons.arrow_drop_down),
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
                                "Select status",
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
                            status = value!.name;
                            idStatus = value.id;
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
                    keyboardType: TextInputType.multiline,
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
                        description = value;
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
                              value: selectedAssignee,
                              onChanged: (value) {
                                setState(() {
                                  assignee = value!.name;
                                  idAssignee = value.id;
                                  selectedAssignee = value;
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
                              value: selectedAccountable,
                              onChanged: (value) {
                                setState(() {
                                  accountable = value!.name;
                                  idAccountable = value.id;
                                  selectedAccountable = value;
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
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: const Color(0xffE1F2F6),
                                ),
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
                        child: Text('Hour: $hour  Minutes: $minutes'),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: 250,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.white,
                                initialDateTime: DateTime.now(),
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (DateTime value) {
                                  setState(() {
                                    hour = value.hour;
                                    minutes = value.minute;
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
                          Text('Start Date: $startdate'),
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              setState(() {
                                sDate = selectedDate;
                                startdate = formatter.format(selectedDate);
                                startdate = (startdate != null)
                                    ? '"$startdate"'
                                    : 'null';
                                if (type == "Milestone") {
                                  startdate = duedate;
                                }
                              });
                            },
                            activeColor: const Color(0xff2595AF),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              inactiveDayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              todayHighlightColor: Color(0xffE1ECC8),
                              todayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text('Due Date: $duedate'),
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              setState(() {
                                dDate = selectedDate;
                                duedate = formatter.format(selectedDate);
                                duedate =
                                    (duedate != null) ? '"$duedate"' : 'null';
                                if (type == "Milestone") {
                                  duedate = startdate;
                                }
                              });
                            },
                            activeColor: const Color(0xff2595AF),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              inactiveDayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              todayHighlightColor: Color(0xffE1ECC8),
                              todayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                              "Select Category",
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
                                          category = value!.name;
                                          idCategory = value.id;
                                          urlCategory =
                                              "/api/v3/categories/$idCategory";
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
                                          version = value!.name;
                                          idVersion = value.id;
                                          urlVersion =
                                              "/api/v3/versions/$idVersion";
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
                                  priority = value!.name;
                                  idPriority = value.id;
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
                category = (category != null) ? '"$category"' : 'null';
                version = (version != null) ? '"$version"' : 'null';
                if (nameOfTask.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter name of task");
                } else if (sDate != null && sDate!.isBefore(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 3000),
                        content: Text("Cannot be start date is past",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                  );
                } else if (dDate != null && dDate!.isBefore(DateTime.now())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 3000),
                        content: Text("Cannot be due date is past",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                  );
                } else if (dDate != null &&
                    sDate != null &&
                    dDate!.isBefore(sDate!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      duration: Duration(milliseconds: 2000),
                      content: Text(
                        "Start date cannot be after due date",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  addTask();
                }
                setState(() {});
              },
              style: button(),
              child: const Text(
                'Create',
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

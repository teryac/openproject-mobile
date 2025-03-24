// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/Property.dart';
import 'package:open_project/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UpdateScreen extends StatefulWidget {
  int id;
  int idProject;
  String name;

  UpdateScreen(this.idProject, this.id, this.name);

  @override
  State<UpdateScreen> createState() => UpdateTasks(idProject, id, name);
}

class UpdateTasks extends State<UpdateScreen> {
  int id;
  String? durationDay;
  String name;
  int idProject;
  String progressValue = 'In progress';
  String personvalue = 'Shaaban Shahin';
  String assignee = 'Shaaban Shahin';
  String accountable = 'Shaaban Shahin';
  String version = 'v 1.0';
  String priority = 'High';
  String category = 'Not found';
  String? apikey;
  String? token;

  TextEditingController desc = TextEditingController();
  TextEditingController percent = TextEditingController();
  TextEditingController task = TextEditingController();
  var startdate = DateTime.now();
  var duedate = DateTime.now();
  DateTime hours = DateTime.now();
  DateTime updateTime = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  var embedded, percentageDone = 0, updatedAt = 'Not changed';
  var nameOfAuthor = 'No person', lockVersion = 0;

  String taskBody = "No body";
  String nameOfType = 'Task';
  String nameOfPriority = 'No Priority';
  String nameOfStatus = 'New';
  String nameOfVersion = 'No version';
  String nameOfAccountable = 'No person';
  String nameOfAssignee = 'No person';
  String? rawOfdescription, subject, dDate, sDate;
  String estimatedTime = "PT0H0M";

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

  void updateTask(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    String newTask = """{\n    "_type": "WorkPackage",\n
        "subject": "Design New Feature",\n    
        "description": {\n        
        "format": "markdown",\n        
        "raw": "Create a detailed design document for the new feature."\n    },\n    
        "priority": {\n        
        "href": "/api/v3/priorities/1",\n        
        "title": "High"\n    },\n   
         "status": {\n        
         "href": "/api/v3/statuses/1",\n        
         "title": "New"\n    },\n    
         "type": {\n        
         "href": "/api/v3/types/2",\n        
         "title": "Feature"\n    },\n    
         "assignee": {\n        
         "href": "/api/v3/users/10",\n        
         "title": "Jane Smith - janesmith"\n    },\n    
         "responsible": {\n        
         "href": "/api/v3/users/11",\n        
         "title": "John Doe - johndoe"\n    },\n    
         "project": {\n        
         "href": "/api/v3/projects/3",\n        
         "title": "Product Development"\n    },\n    
         "version": {\n        
         "href": "/api/v3/versions/5",\n        
         "title": "Release 1.1"\n    },\n    
         "parent": {\n        
         "href": "/api/v3/work_packages/1000",\n        
         "title": "Parent Task"\n    },\n    
         "startDate": "2025-01-20",\n    
         "dueDate": "2025-01-30",\n    
         "estimatedTime": "PT10H",\n    
         "customField1": "Custom Value",\n    
         "customField2": 123,\n    
         "percentageDone": 0\n}""";

    taskBody = """{\n  "_type": "WorkPackage",\n    
        "id": $id,\n    
        "lockVersion": $lockVersion,\n    
        "subject": "$subject",\n    
        "description": {\n        
        "format": "markdown",\n        
        "raw": "$rawOfdescription",\n        
        "html": ""\n    },\n    
        "scheduleManually": false,\n    
        "startDate": "$sDate",\n    
        "dueDate": "$dDate",\n    
        "estimatedTime": "$estimatedTime",\n    
        "derivedEstimatedTime": null,\n    
        "duration": "$durationDay",\n    
        "ignoreNonWorkingDays": true,\n    
        "percentageDone": $percentageDone,\n    
        "remainingTime": null,\n    
        "derivedRemainingTime": null\n  \n}""";

    print(taskBody);
    await http.patch(
      Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id"),
      body: taskBody,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        getTask();
        Fluttertoast.showToast(msg: 'Task of $id has been updated');
      } else {
        Fluttertoast.showToast(msg: 'You cannot update task of $id');
      }
    });
  }

  String convertDuration(String duration) {
    // Remove 'PT' prefix
    duration = duration.replaceFirst('PT', '');

    // Extract hours and minutes
    final RegExp regex = RegExp(r'(\d+)H|(\d+)M');
    int hours = 0, minutes = 0;

    for (final match in regex.allMatches(duration)) {
      if (match.group(1) != null) {
        hours = int.parse(match.group(1)!);
      }
      if (match.group(2) != null) {
        minutes = int.parse(match.group(2)!);
      }
    }

    return 'Hour : $hours ,   Minutes : $minutes';
  }

  void getTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id");
    await http.get(
      uri,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        subject = jsonResponse['subject'];
        task.text = subject!;
        lockVersion = jsonResponse['lockVersion'];
        if (jsonResponse['estimatedTime'] != null) {
          estimatedTime = jsonResponse['estimatedTime'];
        }
        if (jsonResponse['startDate'] != null) {
          sDate = jsonResponse['startDate'];
          //startdate = DateTime.parse(jsonResponse['startDate']);
        }
        if (jsonResponse['dueDate'] != null) {
          dDate = jsonResponse['dueDate'];
          //duedate = DateTime.parse(jsonResponse['dueDate']);
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
        embedded = jsonResponse['_embedded'];
        var assignee = embedded['assignee'];
        if (assignee != null) {
          nameOfAssignee = assignee['name'];
        }
        //Accountable
        embedded = jsonResponse['_embedded'];
        var accountable = embedded['responsible'];
        if (accountable != null) {
          nameOfAccountable = accountable['name'];
        }
        //Version
        if (embedded['version'] != null) {
          var version = embedded['version'];
          nameOfVersion = version['name'];
        }
        //Decription
        var description = jsonResponse['description'];
        var raw = description['raw'];
        if (raw != "") {
          rawOfdescription = raw;
          desc.text = rawOfdescription!;
        }

        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void getAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';
    //Categories
    Response rCategories = await get(
        Uri.parse(
            "https://op.yaman-ka.com/api/v3/projects/$idProject/categories"),
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
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$idProject/types"),
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
            "https://op.yaman-ka.com/api/v3/projects/$idProject/available_assignees"),
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
        if (mounted) {
          setState(() {
            listOfUser = property;
          });
        }
      }
    }
    //Versions
    Response rVersion = await get(
        Uri.parse(
            "https://op.yaman-ka.com/api/v3/projects/$idProject/versions"),
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
        if (mounted) {
          setState(() {
            listOfStatus = property;
          });
        }
      }
    }
  }

  UpdateTasks(this.idProject, this.id, this.name);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask();
    getAllData();
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
                          controller: task,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: subject,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              subject = value.isNotEmpty
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
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    nameOfType,
                                    style: const TextStyle(
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
                              setState(() {});
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
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 5.0),
              ],
            ),
            Column(children: [
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
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nameOfStatus,
                                  style: const TextStyle(
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
                              .map(
                                  (Property item) => DropdownMenuItem<Property>(
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
                            setState(() {});
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
            ]),
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
                    decoration: InputDecoration(
                      labelText: rawOfdescription,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
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
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      nameOfAssignee!,
                                      style: const TextStyle(
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
                                setState(() {});
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
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      nameOfAccountable,
                                      style: const TextStyle(
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
                                setState(() {});
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimates & Time:',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                    Row(children: [
                      const Text('Estimated time:'),
                      CupertinoButton(
                          child: Text(convertDuration(estimatedTime)),
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
                                                "PT${value.hour}H${value.minute}M";
                                          });
                                        },
                                      ),
                                    ));
                          }),
                    ]),
                  ]),
            ),
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
                          Text('Start Date:   $sDate'),
                          EasyDateTimeLine(
                            initialDate: startdate,
                            onDateChange: (selectedDate) {
                              //sDate = selectedDate;
                              setState(() {
                                if (dDate != null &&
                                    selectedDate
                                        .isBefore(DateTime.parse(dDate!))) {
                                  sDate =
                                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                }
                              });

                              //sDate = formatter.format("${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}");
                            },
                            activeColor: const Color(0xff2595AF),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              todayHighlightColor: Color(0xffE1ECC8),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text('Due Date:  $dDate'),
                          EasyDateTimeLine(
                            initialDate: duedate,
                            onDateChange: (selectedDate) {
                              //dDate = selectedDate;
                              dDate =
                                  "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                              if (sDate != null &&
                                  selectedDate
                                      .isAfter(DateTime.parse(sDate!))) {
                                setState(() {
                                  dDate = formatter.format(selectedDate);
                                  Duration duration = DateTime.parse(dDate!)
                                      .difference(DateTime.parse(sDate!));
                                  durationDay = "P${duration.inDays + 1}D";
                                  print("$durationDay days");
                                });
                              }
                            },
                            activeColor: const Color(0xff2595AF),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              todayHighlightColor: Color(0xffE1ECC8),
                            ),
                          ),
                        ]),
                    Row(children: [
                      const Text(
                        "Progress%:",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
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
                                                return;
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
                    Column(children: [
                      Row(
                        children: [
                          const Text(
                            "Category:",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
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
                                  hint: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          category,
                                          style: const TextStyle(
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
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedCategory,
                                  onChanged: (value) {
                                    setState(() {});
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
                                    width: 150,
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
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      //version
                      Row(
                        children: [
                          const Text(
                            "Version:",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
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
                                  hint: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          nameOfVersion,
                                          style: const TextStyle(
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
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedVersion,
                                  onChanged: (value) {
                                    setState(() {});
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
                        ],
                      ),
                    ]),
                    const SizedBox(height: 15.0),
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
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      nameOfPriority,
                                      style: const TextStyle(
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
                                setState(() {});
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
                //updateTask(id.toString());
                // print(lockVersion);
                //print(taskBody);
                setState(() {});
              },
              style: button(),
              child: const Text(
                'Save',
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

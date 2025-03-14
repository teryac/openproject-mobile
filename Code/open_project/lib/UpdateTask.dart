// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
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
  String category = 'Not found';
  String version = 'v 1.0';
  String priority = 'High';
  //String type = 'Task';
  String? apikey;
  String? token;

  TextEditingController desc = TextEditingController();
  TextEditingController percent = TextEditingController();
  TextEditingController task = TextEditingController();
  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();
  DateTime hours = DateTime.now();
  DateTime updateTime = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  var embedded,
      subject = 'Not found',
      startDate = 'Not found',
      dueDate = 'Not found',
      percentageDone = 0,
      updatedAt = 'Not changed';
  var nameOfAuthor = 'No person', lockVersion = 0;

  String taskBody = "No body";
  String nameOfType = 'Task';
  String nameOfPriority = 'Normal';
  String nameOfStatus = 'Normal';
  String nameOfVersion = 'No version';
  String nameOfAccountable = 'No person';
  String nameOfAssignee = 'No person';
  String? rawOfdescription;
  String? estimatedTime;

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

    taskBody = """{\n  "_type": "WorkPackage",\n    
        "id": $id,\n    
        "lockVersion": $lockVersion,\n    
        "subject": "$subject",\n    
        "description": {\n        
        "format": "markdown",\n        
        "raw": "$rawOfdescription",\n        
        "html": ""\n    },\n    
        "scheduleManually": false,\n    
        "startDate": "$startDate",\n    
        "dueDate": "$dueDate",\n    
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
        task.text = subject;
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

  void getUsers() async {
    Uri uri = Uri.parse(
        "https://op.yaman-ka.com/api/v3/projects/$id/available_assignees");
    await http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
      }
    });
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
                          child: Text(estimatedTime!),
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
                                /*startDate =
                                    '${value.year}-${value.month}-${value.day}';*/
                                startDate = formatter.format(value);
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
                            if (value != null &&
                                value.isAfter(DateTime.parse(startDate))) {
                              setState(() {
                                dueDate = formatter.format(value);
                                Duration duration = DateTime.parse(dueDate)
                                    .difference(DateTime.parse(startDate));
                                durationDay = "P${duration.inDays + 1}D";
                                print("$durationDay days");
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
                            print(nameOfVersion);
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'v 1.0',
                            child: Text('v 1.0'),
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
                            print(nameOfPriority);
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
                updateTask(id.toString());
                print(lockVersion);
                //print(taskBody);
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

// ignore_for_file: must_be_immutable, no_logic_in_create_state

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/models/property.dart';
import 'package:open_project/work_packages/detail_of_project.dart';
import 'package:open_project/get_start.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UpdateScreen extends StatefulWidget {
  int id;
  int idProject;
  String name;

  UpdateScreen(this.idProject, this.id, this.name, {super.key});

  @override
  State<UpdateScreen> createState() => UpdateTasks(idProject, id, name);
}

class UpdateTasks extends State<UpdateScreen> {
  int id;
  String name;
  int idProject;
  int? idType,
      idStatus,
      idAssignee,
      idAccountable,
      idPriority,
      idCategory,
      idVersion;

  String? apikey;
  String? token;

  TextEditingController desc = TextEditingController();
  TextEditingController percent = TextEditingController();
  TextEditingController task = TextEditingController();
  var startdate, urlCategory, urlVersion;
  var duedate;
  DateTime? sDate, dDate;
  DateTime updateTime = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

  var embedded, percentageDone = 0, colorType, colorStatus, colorPriority;
  String nameOfAuthor = 'No person';
  int? lockVersion;

  String taskBody = "No body";
  var nameOfCategory = 'Not found';
  String nameOfType = "Not found";
  String nameOfPriority = "Not found";
  String nameOfStatus = "Not found";
  var nameOfVersion = 'No version';
  String nameOfAccountable = 'No person';
  String nameOfAssignee = 'No person';
  String? rawOfdescription, subject;
  String estimatedTime = "PT0H0M";
  String? newTask;

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

  void getAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    String newTask = """{\n    "_type": "WorkPackage",\n
            "id": $id,\n
            "subject": "$subject",\n    
            "lockVersion": $lockVersion,\n    
            "description": {\n        
            "format": "markdown",\n        
            "raw": "$rawOfdescription",\n        
            "html": "<p>Updated description for the Testing API task.</p>"\n    },\n    
            "project": {\n        
            "href": "/api/v3/projects/$idProject",\n        
            "title": "$name"\n    },\n    
            "status": {\n        
            "href": "/api/v3/statuses/$idStatus",\n        
            "title": "$nameOfStatus"\n    },\n    
            "type": {\n        
            "href": "/api/v3/types/$idType",\n        
            "title": "$nameOfType"\n    },\n    
            "priority": {\n        
            "href": "/api/v3/priorities/$idPriority",\n        
            "title": "$nameOfPriority"\n    },\n    
            "assignee": {\n        
            "href": "/api/v3/users/$idAssignee",\n        
            "title": "$nameOfAssignee"\n    },\n        
            "responsible": {\n        
            "href": "/api/v3/users/$idAccountable",\n        
            "title": "$nameOfAccountable"\n    },\n         
            "startDate": $startdate,\n    
            "dueDate": $duedate,\n    
            "estimatedTime": "$estimatedTime",\n    
            "scheduleManually": true,\n    
            "ignoreNonWorkingDays": false,\n    
            "percentageDone": $percentageDone\n}""";

    await http.post(
      Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id/form"),
      body: newTask,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      if (response.statusCode == 200) {
        //Fluttertoast.showToast(msg: 'OK!!!!');
        var jsonResponse = json.decode(response.body);
        var statusValues = jsonResponse['_embedded']['schema']['status']
            ['_embedded']['allowedValues'];
        List<Property> statusList = statusValues
            .map((status) {
              return Property(
                  id: status['id'],
                  name: status['name'],
                  color: status['color']);
            })
            .toList()
            .cast<Property>();

        print(statusList);
        if (mounted) {
          setState(() {
            listOfStatus = statusList;
          });
        }
      }
    });
  }

  void updateTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    String newTask = """{\n    "_type": "WorkPackage",\n
            "id": $id,\n
            "subject": "$subject",\n    
            "lockVersion": $lockVersion,\n    
            "description": {\n        
            "format": "markdown",\n        
            "raw": "$rawOfdescription",\n        
            "html": "<p>Updated description for the Testing API task.</p>"\n    },\n    
            "project": {\n        
            "href": "/api/v3/projects/$idProject",\n        
            "title": "$name"\n    },\n    
            "status": {\n        
            "href": "/api/v3/statuses/$idStatus",\n        
            "title": "$nameOfStatus"\n    },\n    
            "type": {\n        
            "href": "/api/v3/types/$idType",\n        
            "title": "$nameOfType"\n    },\n    
            "priority": {\n        
            "href": "/api/v3/priorities/$idPriority",\n        
            "title": "$nameOfPriority"\n    },\n    
            "assignee": {\n        
            "href": "/api/v3/users/$idAssignee",\n        
            "title": "$nameOfAssignee"\n    },\n    
            "version": {\n        
            "href": $urlVersion,\n        
            "title": "$nameOfVersion"\n},\t\n    
            "responsible": {\n        
            "href": "/api/v3/users/$idAccountable",\n        
            "title": "$nameOfAccountable"\n    },\n    
            "category": {\n        
            "href": $urlCategory,\n        
            "title": "$nameOfCategory"\n},\n    
            "startDate": $startdate,\n    
            "dueDate": $duedate,\n    
            "estimatedTime": "$estimatedTime",\n    
            "scheduleManually": true,\n    
            "ignoreNonWorkingDays": false,\n    
            "percentageDone": $percentageDone\n}""";

    await http.patch(
      Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id"),
      body: newTask,
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      print(newTask);
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
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        subject = jsonResponse['subject'];
        task.text = subject!;
        lockVersion = jsonResponse['lockVersion'];
        if (jsonResponse['estimatedTime'] != null) {
          estimatedTime = jsonResponse['estimatedTime'];
        }
        if (jsonResponse['startDate'] != null) {
          startdate = jsonResponse['startDate'];
          startdate = '"$startdate"';
        }
        if (jsonResponse['date'] != null) {
          duedate = jsonResponse['date'];
          startdate = jsonResponse['date'];
          duedate = '"$duedate"';
          startdate = '"$startdate"';
        }
        if (jsonResponse['dueDate'] != null) {
          duedate = jsonResponse['dueDate'];
          duedate = '"$duedate"';
        }
        if (jsonResponse['percentageDone'] != 0) {
          percentageDone = jsonResponse['percentageDone'];
        }
        //Category
        embedded = jsonResponse['_embedded'];
        var category = embedded['category'];
        if (category != null) {
          idCategory = category['id'];
          nameOfCategory = category['name'];
          urlCategory = "/api/v3/categories/$idCategory";
        }
        embedded = jsonResponse['_embedded'];
        //Type
        var type = embedded['type'];
        idType = type['id'];
        nameOfType = type['name'];
        colorType = type['color'];
        //Priority
        embedded = jsonResponse['_embedded'];
        var priority = embedded['priority'];
        idPriority = priority['id'];
        nameOfPriority = priority['name'];
        colorPriority = priority['color'];
        //Status
        var status = embedded['status'];
        idStatus = status['id'];
        nameOfStatus = status['name'];
        colorStatus = status['color'];
        //CreatedBy
        var author = embedded['author'];
        nameOfAuthor = author['name'];
        //Assignee
        embedded = jsonResponse['_embedded'];
        var assignee = embedded['assignee'];
        if (assignee != null) {
          idAssignee = assignee['id'];
          nameOfAssignee = assignee['name'];
        }
        //Accountable
        embedded = jsonResponse['_embedded'];
        var accountable = embedded['responsible'];
        if (accountable != null) {
          idAccountable = accountable['id'];
          nameOfAccountable = accountable['name'];
        }
        //Version
        if (embedded['version'] != null) {
          var version = embedded['version'];
          idVersion = version['id'];
          nameOfVersion = version['name'];
          urlVersion = "/api/v3/versions/$idVersion";
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

          return Property(id: idCategory, name: pro, color: "");
        }).toList();
        property.add(Property(id: -1, name: 'Not found', color: ""));
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
          String color = data['color'];
          int idProperty = data['id'];

          return Property(id: idProperty, name: pro, color: color);
        }).toList();
        if (mounted) {
          setState(() {
            listOfPriority = property;
          });
        }
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
          String color = data['color'] ?? '#000000';
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

          return Property(id: idUser, name: pro, color: "");
        }).toList();
        property.add(Property(id: -1, name: 'Not found', color: ""));
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

          return Property(id: idVersion, name: pro, color: "");
        }).toList();
        setState(() {
          listOfVersion = property;
          property.add(Property(id: -1, name: 'No version', color: ""));
        });
      }
    }
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // add alpha if missing
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  UpdateTasks(this.idProject, this.id, this.name);

  @override
  void initState() {
    super.initState();
    getTask();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    getAll();
    return Scaffold(
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
                    //Type
                    SizedBox(
                      height: 63, // Match this height with the TextField height
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.only(left: 3),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<Property>(
                            onMenuStateChange: (isOpen) {
                              getAll();
                            },
                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    nameOfType,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: getColorFromHex(
                                          colorType ?? '#000000'),
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
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: getColorFromHex(item.color),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedType,
                            onChanged: (value) {
                              setState(() {
                                nameOfType = value!.name;
                                idType = value.id;
                                colorType = value.color;
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.only(left: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<Property>(
                          onMenuStateChange: (isOpen) {
                            getAll();
                          },
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nameOfStatus,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: getColorFromHex(
                                        colorStatus ?? '#000000'),
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
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: getColorFromHex(item.color),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                              .toList(),
                          value: selectedStatus,
                          onChanged: (value) {
                            setState(() {
                              nameOfStatus = value!.name;
                              idStatus = value.id;
                              colorStatus = value.color;
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
                              color: Colors.green[100],
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
                              color: Colors.white,
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
              Row(
                children: [
                  const Padding(
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
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    nameOfAuthor,
                    style: const TextStyle(
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
            ]),
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
                //Description
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
                      setState(() {
                        rawOfdescription = value;
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
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      nameOfAssignee,
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
                                setState(() {
                                  nameOfAssignee = value!.name;
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
                                setState(() {
                                  nameOfAccountable = value!.name;
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
            // Estimates Time
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimates Time:',
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
                                        initialDateTime: DateTime.now(),
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
                    //Start Date
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Date:   $startdate'),
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              setState(() {
                                sDate = selectedDate;
                                startdate = formatter.format(selectedDate);
                                startdate = (startdate != null)
                                    ? '"$startdate"'
                                    : 'null';
                                if (nameOfType == "Milestone") {
                                  duedate = startdate;
                                }
                              });
                            },
                            activeColor: const Color(0xff2595AF),
                            dayProps: const EasyDayProps(
                              inactiveDayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
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
                          //Due Date
                          Text('Due Date:  $duedate'),
                          EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              setState(() {
                                dDate = selectedDate;
                                duedate = formatter.format(selectedDate);
                                duedate =
                                    (duedate != null) ? '"$duedate"' : 'null';
                                if (nameOfType == "Milestone") {
                                  startdate = duedate;
                                }
                              });
                            },
                            activeColor: const Color(0xff2595AF),
                            dayProps: const EasyDayProps(
                              todayHighlightStyle:
                                  TodayHighlightStyle.withBackground,
                              todayHighlightColor: Color(0xffE1ECC8),
                              inactiveDayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              todayStyle: DayStyle(
                                borderRadius: 48.0,
                                dayNumStyle: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ]),
                    Row(children: [
                      //Progress
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
                                          nameOfCategory,
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
                                    setState(() {
                                      nameOfCategory = value!.name;
                                      idCategory = value.id;
                                      selectedCategory = value;
                                      urlCategory =
                                          "/api/v3/categories/$idCategory";
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
                                    setState(() {
                                      nameOfVersion = value!.name;
                                      idVersion = value.id;
                                      selectedVersion = value;
                                      urlVersion =
                                          "/api/v3/versions/$idVersion";
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
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: getColorFromHex(
                                            colorPriority ?? '#000000'),
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
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: getColorFromHex(item.color),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: selectedPriority,
                              onChanged: (value) {
                                setState(() {
                                  nameOfPriority = value!.name;
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
                                  color: Colors.white,
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
                if (task.text.isEmpty) {
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
                } else if (nameOfCategory == 'Not found' &&
                    nameOfVersion == 'No version') {
                  urlCategory = null;
                  nameOfCategory = '';
                  urlVersion = null;
                  nameOfVersion = '';
                  updateTask();
                  nameOfCategory = 'Not found';
                  nameOfVersion = 'No version';
                  getTask();
                } else if (nameOfCategory != 'Not found' &&
                    nameOfVersion == 'No version') {
                  urlCategory = '"$urlCategory"';
                  urlVersion = null;
                  nameOfVersion = '';
                  updateTask();
                  nameOfVersion = 'No version';
                  getTask();
                } else if (nameOfVersion != 'No version' &&
                    nameOfCategory == 'Not found') {
                  urlVersion = '"$urlVersion"';
                  urlCategory = null;
                  nameOfCategory = '';
                  updateTask();
                  nameOfCategory = 'Not found';
                  getTask();
                } else if (nameOfVersion != 'No version' &&
                    nameOfCategory != 'Not found') {
                  urlVersion = '"$urlVersion"';

                  urlCategory = '"$urlCategory"';

                  updateTask();
                  getTask();
                } else {
                  updateTask();
                  nameOfCategory = 'Not found';
                  nameOfVersion = 'No version';
                  getTask();
                }
                setState(() {});
              },
              style: button(),
              child: const Text(
                'Update',
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

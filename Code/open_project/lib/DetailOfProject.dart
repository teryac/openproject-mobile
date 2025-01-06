import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/AddTask.dart';
import 'package:open_project/Login.dart';
import 'package:open_project/UpdateTask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart' as badges;

import 'Subjects.dart';

// ignore: must_be_immutable
class StateDetail extends StatefulWidget {
  int id;
  String name;

  StateDetail(this.id, this.name);

  @override
  State<StateDetail> createState() => Detail(id, name);
}

class Detail extends State<StateDetail> {
  String name;
  int id;
  late var description;
  List<Subjects> dataOfSubject = [];
  String? apikey;
  String? token;

  Detail(this.id, this.name);

  void deleteTask(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    await http.delete(
      Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id"),
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      if (response.statusCode == 204) {
        getTask();
        Fluttertoast.showToast(msg: 'task of $id has been deleted');
      } else {
        Fluttertoast.showToast(msg: 'you cannot delete task of $id');
      }
    });
  }

  void getTask() {
    Uri uri =
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/work_packages");

    http.get(uri).then((response) {
      var jsonResponse = jsonDecode(response.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        List<Subjects> subjects = elements.map((data) {
          // Safely access the raw field
          String rawDescription =
              data['description']?['raw'] ?? 'No description available';
          String sub = data['subject'];

          int idTask = data['id'];
          String status =
              data['_links']?['status']?['title'] ?? 'No Status available';

          return Subjects(
              id: idTask,
              subject: sub,
              description: rawDescription,
              status: status);
        }).toList();

        //if (mounted) {
        setState(() {
          dataOfSubject = subjects;
        });
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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            setState(() {});
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          mini: true,
          elevation: 5.0,
          shape: const CircleBorder(),
          backgroundColor: Colors.lightBlue,
          foregroundColor: const Color(0xfff8f8f8),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddScreen(id, name)));
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.lightBlue,
        height: 50.0,
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
      ),
      body: dataOfSubject.isEmpty
          ? const Center(
              child: Text(
              'No tasks available...',
              style: TextStyle(fontSize: 20.0),
            ))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(12.0),
                    itemCount: dataOfSubject.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      String sub = dataOfSubject[index].subject;
                      String desc = dataOfSubject[index].description;
                      int id = dataOfSubject[index].id;
                      return Card(
                        borderOnForeground: true,
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(sub,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(desc),
                              trailing: badges.Badge(
                                badgeContent: Text(
                                  dataOfSubject[index].status,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                badgeAnimation:
                                    const badges.BadgeAnimation.rotation(
                                  animationDuration: Duration(seconds: 1),
                                  colorChangeAnimationDuration:
                                      Duration(seconds: 1),
                                  loopAnimation: false,
                                  curve: Curves.fastOutSlowIn,
                                  colorChangeAnimationCurve: Curves.easeInCubic,
                                ),
                                badgeStyle: badges.BadgeStyle(
                                  shape: badges.BadgeShape.square,
                                  badgeColor: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(20.0),
                                  elevation: 0,
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                child: Text(
                                  sub.isNotEmpty ? sub[0] : 'N/A',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ),
                              onLongPress: () {
                                setState(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Do you want delete task $sub ?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deleteTask(id.toString());
                                                  });
                                                },
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ],
                                        );
                                      });
                                });
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateScreen(
                                          dataOfSubject[index].id, name)),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  ButtonStyle button() {
    ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 89, 142, 167),
      elevation: 0,
      minimumSize: const Size(327, 50),
      padding: const EdgeInsets.symmetric(horizontal: 35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );

    return raisedButtonStyle;
  }
}

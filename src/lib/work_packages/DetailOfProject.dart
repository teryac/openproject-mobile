import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:open_project/add_work_package/AddTask.dart';
import 'package:open_project/ProcessingTasks.dart';
import 'package:open_project/home/ShowProjects.dart';
import 'package:open_project/add_work_package/UpdateTask.dart';
import 'package:badges/badges.dart' as badges;

import '../Subjects.dart';

// ignore: must_be_immutable
class StateDetail extends StatefulWidget {
  int id;
  String name;

  StateDetail(this.id, this.name, {super.key});

  @override
  State<StateDetail> createState() => Detail(id, name);
}

class Detail extends State<StateDetail> {
  String name;
  int id;
  List<Subjects> dataOfSubject = [];

  Detail(this.id, this.name);

  ProcessingTasks tasks = ProcessingTasks();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      List<Subjects> project = await tasks.getTask(id);
      setState(() {
        dataOfSubject = project;
      });
    } catch (e) {
      print("Error: $e");
    }
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
                MaterialPageRoute(builder: (context) => const ShowScreen()));
            setState(() {});
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xfff8f8f8),
        animationDuration: const Duration(seconds: 5),
        animationCurve: Curves.bounceInOut,
        color: Colors.lightBlue,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(Icons.add, color: Color(0xfff8f8f8)),
            label: 'Add task',
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
        onTap: (index) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddScreen(id, name)));
        },
      ),
      body: dataOfSubject.isEmpty
          ? const Center(
              child: Text(
              'No tasks available...',
              style: TextStyle(fontSize: 20.0),
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 5.0),
                  child: Text(
                    "List of tasks:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(12.0),
                    itemCount: dataOfSubject.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      String sub = dataOfSubject[index].subject;
                      String desc = dataOfSubject[index].description;
                      return Card(
                        borderOnForeground: true,
                        elevation: 3.0,
                        color: Colors.grey[50],
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
                                    const badges.BadgeAnimation.fade(
                                  animationDuration: Duration(seconds: 4),
                                  loopAnimation: false,
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
                                                    tasks.deleteTask(
                                                        dataOfSubject[index]
                                                            .id);
                                                    Navigator.pop(context);
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
                                          id, dataOfSubject[index].id, name)),
                                );
                              },
                            ),
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

// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_project/models/project.dart';
import 'package:open_project/models/property.dart';
import 'package:open_project/work_packages/detail_of_project.dart';
import 'package:open_project/work_packages/logic/processing_projects.dart';
import 'package:open_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowScreen extends StatefulWidget {
  const ShowScreen({super.key});

  @override
  State<ShowScreen> createState() => Show();
}

class Show extends State<ShowScreen> {
  TextEditingController apiKey = TextEditingController();
  TextEditingController enteredToken = TextEditingController();
  List<Project> data = [];
  late String name, user = "";
  late int id, idUser;
  List<Property> listOfUser = [];
  late String description;
  String? apikey;
  String? token;
  String username = 'apikey';
  String password =
      '6905fd9498adf5f3f7024adac280c2d45fd042622094484cc56dc77aed52773e';
  ProcessingProjects projects = ProcessingProjects();

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';
    Response r = await get(Uri.parse("https://op.yaman-ka.com/api/v3/users/me"),
        headers: <String, String>{'authorization': basicAuth});
    if (r.statusCode == 200) {
      var jsonResponse = jsonDecode(r.body);
      user = jsonResponse['name'];

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    //getProjects();
    fetchProjects();
  }

  void fetchPublicProjects() async {
    List<Project> project = await projects.getData();
    setState(() {
      data = project;
    });
  }

  void fetchProjects() async {
    List<Project> project = await projects.getProjects();
    setState(() {
      data = project;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("List of projects",
            style: TextStyle(fontSize: 25, color: Colors.white)),
      ),
      body: data.isEmpty
          ? const Center(
              child: Text(
                'No projects available...',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    'Hello $user',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Welcome back",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 8.0),
                  child: Text(
                    "Projects:",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: data.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      name = data[index].name;
                      description = data[index].description;
                      id = data[index].id;
                      return Card(
                        borderOnForeground: true,
                        color: Colors.grey[100],
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                                title: Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(description),
                                /*trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_sharp),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StateDetail(
                                              data[index].id, data[index].name),
                                        ),
                                      );
                                    });
                                  },
                                ),*/
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StateDetail(
                                            data[index].id, data[index].name)),
                                  );
                                })
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
}

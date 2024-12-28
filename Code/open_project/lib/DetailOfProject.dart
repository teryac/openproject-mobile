import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/AddTask.dart';
import 'package:open_project/UpdateTask.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      var elements = embedded['elements'] as List;
      List<Subjects> subjects = elements.map((data) {
        // Safely access the raw field
        String rawDescription =
            data['description']?['raw'] ?? 'No description available';
        String subject = data['subject'];
        id = data['id'];

        return Subjects(id: id, subject: subject, description: rawDescription);
      }).toList();

      if (mounted) {
        setState(() {
          dataOfSubject = subjects;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(name, style: const TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddScreen(id, name)));
          },
          child: const Icon(Icons.add)),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            //shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(12.0),
            itemCount: dataOfSubject.length,
            itemBuilder: (BuildContext ctx, int index) {
              return Card(
                borderOnForeground: true,
                elevation: 3.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(dataOfSubject[index].subject),
                      subtitle: Text(dataOfSubject[index].description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            deleteTask(dataOfSubject[index].id.toString());
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateScreen(dataOfSubject[index].id, name)),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          )),
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

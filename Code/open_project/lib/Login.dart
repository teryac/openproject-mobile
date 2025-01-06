// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/DetailOfProject.dart';
import 'package:open_project/Project.dart';
import 'package:open_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => Login();
}

class Login extends State<LoginScreen> {
  TextEditingController apiKey = TextEditingController();
  TextEditingController enteredToken = TextEditingController();
  List<Project> data = [];
  late String name;
  late int id;
  late var description;
  String? apikey;
  String? token;
  String username = 'apikey';
  String password =
      '6905fd9498adf5f3f7024adac280c2d45fd042622094484cc56dc77aed52773e';

  void getData() {
    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/projects");

    http.get(uri).then((response) {
      var jsonResponse = jsonDecode(response.body);
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;

// Loop through the elements to extract 'description' -> 'raw'
      List<Project> projects = elements.map((data) {
        // Safely access the raw field
        String rawDescription =
            data['description']?['raw'] ?? 'No description available';
        String name = data['name'];
        id = data['id'];

        return Project(description: rawDescription, name: name, id: id);
      }).toList();

      setState(() {
        data = projects;
      });
    });
  }

  void getProjects() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('apikey', username);
    await prefs.setString('password', password);

    apikey = prefs.getString('apikey');
    token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    Response r = await get(Uri.parse('https://op.yaman-ka.com/api/v3/projects'),
        headers: <String, String>{'authorization': basicAuth});
    if (r.statusCode == 200) {
      var jsonResponse = jsonDecode(r.body);

      // Access the '_embedded' object
      var embedded = jsonResponse['_embedded'];

      // Access the 'elements' list
      var elements = embedded['elements'] as List;

      // Loop through the elements to extract 'description' -> 'raw'
      List<Project> projects = elements.map((data) {
        // Safely access the raw field
        String rawDescription =
            data['description']?['raw'] ?? 'No description available';
        String name = data['name'];
        id = data['id'];

        return Project(description: rawDescription, name: name, id: id);
      }).toList();

      setState(() {
        data = projects;
      });
    } else {
      Fluttertoast.showToast(msg: 'You dont sign up');
    }
  }

  @override
  void initState() {
    super.initState();
    //getData();
    getProjects();
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
              child: Text('No projects available...',
                  style: TextStyle(fontSize: 20.0)))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///const SizedBox(height: 15.0),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    "Hi Shaaban",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                  ),
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
                Expanded(
                    child: ListView.builder(
                  //shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: data.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    name = data[index].name;
                    description = data[index].description;

                    id = data[index].id;
                    return Card(
                        borderOnForeground: true,
                        color: Colors.white,
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
                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_sharp),
                                  onPressed: () {
                                    setState(() {
                                      //data.removeAt(index);
                                    });
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StateDetail(
                                              data[index].id,
                                              data[index].name)));
                                  //Fluttertoast.showToast(msg: data[index].name);
                                })
                          ],
                        ));
                  },
                )),
              ],
            ),
    );
  }
}

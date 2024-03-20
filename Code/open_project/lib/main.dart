import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:open_project/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailOfProject.dart';
import 'Project.dart';

void main() {
  runApp(MyApp());
}

ButtonStyle button() {
  ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.lightBlue,
    elevation: 0,
    minimumSize: Size(327, 50),
    padding: EdgeInsets.symmetric(horizontal: 35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );

  return raisedButtonStyle;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          primaryColor: Colors.blue,
          useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController apiKey = TextEditingController();
  TextEditingController enteredToken = TextEditingController();
  List<Project> data = [];
  late String name;
  late int id;
  String? apikey;
  String? token;
  String username = 'apikey';
  String password =
      '6905fd9498adf5f3f7024adac280c2d45fd042622094484cc56dc77aed52773e';

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
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;
      setState(() {
        Iterable<Project> projects =
            elements.map((data) => Project(id: data['id'], name: data['name']));
        data = projects.toList();
      });
    } else {
      Fluttertoast.showToast(msg: 'You dont sign up');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/projects");

    http.get(uri).then((response) {
      var jsonResponse = jsonDecode(response.body);
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;

      setState(() {
        Iterable<Project> projects =
            elements.map((data) => Project(id: data['id'], name: data['name']));
        data = projects.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Center(
            child: Text("Open project",
                style: TextStyle(fontSize: 25, color: Colors.white))),
      ),
      body: Column(
        children: [
          const Image(
            image: AssetImage('images/openproject.png'),
            width: 125,
            height: 125,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: apiKey,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.api_sharp),
                labelText: "Enter Api key",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: enteredToken,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.token),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye_sharp),
                ),
                labelText: "Enter token",
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {}, child: const Text('Forgetpassword?')),
          ),
          ElevatedButton(
            onPressed: () {
              /*if (apiKey.text == username && enteredToken.text == password) {
                getProjects();
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StateDetail(id, name)));*/
                apiKey.text = '';
                enteredToken.text = '';
              } else {
                Fluttertoast.showToast(msg: 'Enter values correctly please');
              }*/
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
              setState(() {});
            },
            style: button(),
            child: const Text(
              'Login now...',
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(20.0),
            itemCount: data.length,
            itemBuilder: (BuildContext ctx, int index) {
              name = data[index].name;
              id = data[index].id;
              return ListTile(
                  title: Text(name),
                  subtitle: Text(id.toString()),
                  //tileColor: Color.fromARGB(255, 146, 105, 105),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        data.removeAt(index);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StateDetail(data[index].id, data[index].name)));
                    //Fluttertoast.showToast(msg: data[index].name);
                  });
            },
          )),
        ],
      ),
    );
  }
}

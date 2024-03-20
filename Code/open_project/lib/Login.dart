import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:open_project/DetailOfProject.dart';
import 'package:open_project/Project.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => Login();
}

class Login extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController enteredToken = TextEditingController();
  List<Project> data = [];
  late String name;
  late int id;
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

      setState(() {
        Iterable<Project> projects =
            elements.map((data) => Project(id: data['id'], name: data['name']));
        data = projects.toList();
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
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Login",
            style: TextStyle(fontSize: 25, color: Colors.white)),
      ),
      body: Column(
        children: [
          const Image(
            image: AssetImage('images/openproject.png'),
            width: 125,
            height: 125,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Enter Apikey",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: enteredToken,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.token),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye_sharp),
                ),
                labelText: "Enter Token",
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {}, child: const Text('Forgetpassword?')),
          ),
          GradientButton(
            increaseWidthBy: 250,
            increaseHeightBy: 10,
            child: Text('Login',
                style: TextStyle(fontSize: 25, color: Colors.white)),
            callback: () {
              Fluttertoast.showToast(msg: 'Done');
            },
            gradient:
                LinearGradient(colors: [Colors.blue, Colors.purpleAccent]),
            shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
          ),
          /*ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            style: button(),
            child: Text(
              'Login now...',
              style: TextStyle(fontSize: 25),
            ),
          ),*/
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

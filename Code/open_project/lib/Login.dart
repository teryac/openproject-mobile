// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/DetailOfProject.dart';
import 'package:open_project/Project.dart';
import 'package:open_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /* void getData() {
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
  }*/

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
      /*var jsonResponse = jsonDecode(r.body);
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;
      setState(() {
        //var des = elements['description'];
        Iterable<Project> projects = elements.map((data) =>
            Project(description: data['description'], name: data['name']));
        data = projects.toList();

      });*/
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
    // TODO: implement initState
    super.initState();
    getProjects();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("List of projects",
            style: TextStyle(fontSize: 25, color: Colors.white)),
      ),
      body: Column(
        children: [
          /*const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('images/openproject.png'),
              width: 175,
              height: 175,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              controller: apiKey,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Enter Apikey",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              controller: enteredToken,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.token),
                suffixIcon: IconButton(
                  color: Colors.grey,
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
                onPressed: () {},
                child: const Text('Forgot password?',
                    style: TextStyle(fontSize: 15))),
          ),
          GradientButton(
            increaseWidthBy: 250,
            increaseHeightBy: 10,
            child: const Text('Login',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            callback: () {
              if (apiKey.text == username && enteredToken.text == password) {
                getProjects();
                apiKey.text = '';
                enteredToken.text = '';
              } else {
                Fluttertoast.showToast(msg: 'Enter values correctly please');
              }
            },
            gradient: const LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent]),
            shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.75),
          ),
          ElevatedButton(
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
            //shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(12.0),
            itemCount: data.length,
            itemBuilder: (BuildContext ctx, int index) {
              name = data[index].name;
              description = data[index].description;

              id = data[index].id;
              return Card(
                  borderOnForeground: true,
                  elevation: 3.0,
                  child: Column(
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                          title: Text(name),
                          subtitle: Text(description.toString()),
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
                                    builder: (context) => StateDetail(
                                        data[index].id, data[index].name)));
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

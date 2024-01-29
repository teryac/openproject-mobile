import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => Login();
}

class Login extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void getUser() async {
    String username = 'apikey';
    String password =
        '6905fd9498adf5f3f7024adac280c2d45fd042622094484cc56dc77aed52773e';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    Response r = await get(Uri.parse('https://op.yaman-ka.com/api/v3/projects'),
        headers: <String, String>{'authorization': basicAuth});
    print(r.statusCode);
    print(r.body);
    Fluttertoast.showToast(msg: 'Done...');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Welcome to back")),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: "Enter Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
              //isDense: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: password,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.password),
              labelText: "Enter Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
              //isDense: true,
            ),
          ),
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
        ),
      ]),
    );
  }
}

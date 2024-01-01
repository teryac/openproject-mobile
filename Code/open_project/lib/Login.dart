import 'package:flutter/material.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => Login();
}

class Login extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Welcome to back")),
      ),
      body: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: email,
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
      ),
    );
  }
}

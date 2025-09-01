import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/GetServer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetToken extends StatefulWidget {
  const GetToken({super.key});

  @override
  State<StatefulWidget> createState() => Token();
}

ButtonStyle buttonToken() {
  ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    elevation: 10,
    minimumSize: const Size(360, 50),
    padding: const EdgeInsets.symmetric(horizontal: 35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  return raisedButtonStyle;
}

class Token extends State<GetToken> {
  String apiKey = 'apikey';
  String token =
      '6905fd9498adf5f3f7024adac280c2d45fd042622094484cc56dc77aed52773e';
  TextEditingController enteredToken = TextEditingController();
  String? error;

  void checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('apikey', apiKey);

    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apiKey:$token'))}';

    Response r = await get(Uri.parse('https://op.yaman-ka.com/api/v3/projects'),
        headers: <String, String>{'authorization': basicAuth});
    if (r.statusCode == 200) {
      await prefs.setString('password', enteredToken.text);
      /*var jsonResponse = jsonDecode(r.body);
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;
      setState(() {
        Iterable<Project> projects = elements.map((data) => Project(
            description: data['description'],
            name: data['name'],
            id: data['id']));
        data = projects.toList();
      });*/
      Fluttertoast.showToast(
          msg: 'Done :)',
          textColor: Colors.white,
          backgroundColor: Colors.green);
    } else {
      Fluttertoast.showToast(
          msg: 'You dont sign up',
          textColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double? circleSize = screenSize.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 19.0),
              child: Row(
                children: [
                  Image(
                    image: const AssetImage('images/list.png'),
                    width: circleSize * 0.42,
                    height: screenSize.height * 0.4,
                  ),
                  SizedBox(width: circleSize * 0.03),
                  Image(
                    image: const AssetImage('images/user.png'),
                    width: circleSize * 0.5,
                    height: screenSize.height * 0.4,
                  ),
                ],
              ),
            ),
            const Text(
              "Step into your workspace",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                textAlign: TextAlign.center,
                "Enter your API token to edit tasks, access private projects, and collaborate with your team.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter Your API token",
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "To get your API token, go to account settings on the website. For help, see the guide below.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: TextField(
                controller: enteredToken,
                maxLines: 2,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "API Token",
                  errorText: error,
                ),
                onChanged: (value) {},
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Colors.white,
                        child: SingleChildScrollView(
                          //height: screenSize.height * 0.5,
                          //width: screenSize.width * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "How to get API tokens?",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ),
                                  ],
                                ),
                                const Image(
                                  image: AssetImage('images/token.png'),
                                ),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      "Accessing Account Settings",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "To begin, navigate to the website and click on the profile icon. Next, select the 'My Account' tab as illustrated in the image above.Next, select the 'Access tokens' tab.",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('How to get API tokens?'),
              ),
            ),
            SizedBox(
              width: 350.0,
              child: ElevatedButton(
                style: buttonServer(),
                onPressed: () {
                  if (enteredToken.text.isNotEmpty) {
                    checkToken();
                    enteredToken.text = "";
                    error = "";
                    setState(() {});
                  } else {
                    error = "Enter API Token.";
                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                child: const Text(
                  "Access workspace",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}

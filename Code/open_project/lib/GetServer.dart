// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:open_project/GetToken.dart';
import 'package:open_project/ProcessingServer.dart';

class GetServer extends StatefulWidget {
  const GetServer({super.key});

  @override
  State<StatefulWidget> createState() => Server();
}

ButtonStyle buttonServer() {
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

class Server extends State<GetServer> {
  String? error;
  var server;
  TextEditingController enteredServer = TextEditingController();
  ProcessingServer ser = ProcessingServer();

  @override
  void initState() {
    super.initState();
    enteredServer.text = "https://";
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
            Image(
              image: const AssetImage('images/Server.png'),
              width: circleSize,
              height: screenSize.height * 0.4,
              fit: BoxFit.contain,
            ),
            const Text(
              "Your projects, One link away",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Enter the server URL to connect with your team’s workspace and access your ongoing projects.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Enter the URL of your project host",
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "You can copy the URL link of the website of your OpenProject from the browser, and paste it here.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: TextField(
                controller: enteredServer,
                maxLines: 1,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Enter Server",
                  errorText: error,
                ),
                onChanged: (value) {
                  server = value;
                },
              ),
            ),
            /*Align(
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
            ),*/
            const SizedBox(height: 10.0),
            SizedBox(
              width: 350.0,
              child: ElevatedButton(
                style: buttonServer(),
                onPressed: () {
                  server = ser.getServer(enteredServer.text);
                  if (server == null || enteredServer.text.isEmpty) {
                    error = "Please enter a valid server URL.";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(milliseconds: 500),
                        content: Text(
                          "Failure :(",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    );
                    setState(() {});
                    return;
                  } else if (server.startsWith("http://")) {
                    error =
                        "Please enter a valid server URL starting with https.";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 500),
                        content: Text(
                          "Failure :(",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    );
                    setState(() {});
                    return;
                  } else {
                    error = null;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        duration: Duration(milliseconds: 500),
                        content: Text(
                          "Connected :)",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GetToken(),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Connect to Server",
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

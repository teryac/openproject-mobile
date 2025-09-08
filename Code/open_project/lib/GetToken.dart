import 'package:flutter/material.dart';
import 'package:open_project/GetServer.dart';
import 'package:open_project/TokenProcessing.dart';

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
  TextEditingController enteredToken = TextEditingController();
  String? error, getToken;
  TokenProcessing token = TokenProcessing();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*if (getToken != null) {
      enteredToken.text = getToken!;
    }*/
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
              child: Text(
                "Enter Your API token",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                textAlign: TextAlign.center,
                "To get your API token, go to account settings on the website. For help, see the guide below.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: TextField(
                controller: enteredToken,
                //maxLines: 2,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "API Token",
                  errorText: error,
                ),
                onChanged: (value) {
                  enteredToken.text = value;
                },
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
                    token.checkToken(enteredToken.text);
                    enteredToken.text = "";
                    error = null;
                    setState(() {});
                  } else {
                    error = "Enter API Token.";
                    //Navigator.pop(context);
                    setState(() {});
                    return;
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

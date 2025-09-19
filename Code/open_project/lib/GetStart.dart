// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:open_project/auth/GetServer.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => Start();
}

ButtonStyle button() {
  ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 243, 233, 233),
    elevation: 10,
    minimumSize: const Size(360, 50),
    padding: const EdgeInsets.symmetric(horizontal: 35),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  return raisedButtonStyle;
}

class Start extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage('assets/images/emp.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Bottom container (existing content)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Welcome to your all in one project manager",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Collaborate with your team, check your tasks, and update your supervisor on progress.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const GetServer()));
                            /*showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: SizedBox(
                                    height: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            controller: apiKey,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.api_sharp),
                                              suffixIcon: Icon(Icons.email),
                                              labelText: "Enter Api key",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          TextField(
                                            controller: enteredToken,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.token),
                                              suffixIcon: Icon(
                                                  Icons.remove_red_eye_sharp),
                                              labelText: "Enter token",
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Contact by support !!!");
                                              },
                                              child: const Text(
                                                  'Forget password?'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 320.0,
                                            child: ElevatedButton(
                                              style: button(),
                                              onPressed: () {
                                                if (apiKey.text == username &&
                                                    enteredToken.text ==
                                                        password) {
                                                  apiKey.text = "";
                                                  enteredToken.text = "";
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      content: Text(
                                                        "Login successful",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                  );
                                                  setState(() {});
                                                } else {
                                                  apiKey.text = "";
                                                  enteredToken.text = "";
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      content: Text(
                                                        "Login failed",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                }
                                              },
                                              child: const Text(
                                                "Login",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          */
                          },
                          style: button(),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // === Your top floating logo container ===
          Positioned(
            top: 70,
            left: 140,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    color: Colors.white,
                    image: AssetImage('assets/images/openproject.png'),
                    width: 40,
                    height: 40,
                  ),
                  Image(
                    color: Colors.white,
                    image: AssetImage('assets/images/op.png'),
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(width: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

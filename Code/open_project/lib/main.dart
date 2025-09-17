import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_project/GetStart.dart';
import 'package:open_project/GetToken.dart';
import 'package:open_project/core/util/bloc_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  _attachBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue, useMaterial3: true),
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
  /* void getData() {
    Uri uri = Uri.parse("https://op.yaman-ka.com/api/v3/projects");

    http.get(uri).then((response) {
      var jsonResponse = jsonDecode(response.body);
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;

      setState(() {
        Iterable<Project> projects = elements.map((data) =>
            Project(description: data['description'], name: data['name']));
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
        Iterable<Project> projects = elements.map((data) => Project(
            description: data['description'],
            name: data['name'],
            id: data['id']));
        data = projects.toList();
      });
    } else {
      Fluttertoast.showToast(msg: 'You dont sign up');
    }
  }*/

  void checkServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? server = prefs.getString('Server');
    Timer(const Duration(seconds: 2), () {
      if (server == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const StartScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const GetToken()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkServer();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _offsetY = 0.0; // Move to the original position
        _opacity = 1.0; // Make it fully visible
      });
    });

    // Initialize the AnimationController with a duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 200), // Rotation duration
    )..repeat(); // Repeating the animation indefinitely

    // Define the rotation animation (from 0 to 1 for a full turn)
    _rotation = Tween<double>(begin: 0.0, end: 6.18).animate(_controller);

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
    _randomOffset = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );*/
    //initialization();
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    //double? circleSize = screenSize.width;
    return const Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/imagesopenproject.png'),
              width: 75,
              height: 75,
            ),
            Image(
              image: AssetImage('assets/imagesop.png'),
              width: 150,
              height: 125,
            ),
            /*SizedBox(height: circleSize * 0.3),
              SizedBox(
                height: circleSize * 0.6,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    // Circular track (behind the rotating circles)
                    CustomPaint(
                      size: const Size(300, 400),
                      painter: CircleTrackPainter(),
                    ),
                    const Center(
                      child: ClipOval(
                        child: Image(
                          color: Colors.blueAccent,
                          image: AssetImage('assets/imagesopenproject.png'),
                          width: 155,
                          height: 155,
                        ),
                      ),
                    ),
                    // Apply RotationTransition to the entire stack of circles
                    RotationTransition(
                      turns: _rotation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            right: 140,
                            top: 0,
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 75,
                            left: 75,
                            child: ClipOval(
                              child: Container(
                                color: Colors.amber,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: circleSize * 0.78,
                            child: ClipOval(
                              child: Container(
                                color: Colors.purple,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 75,
                            right: 75,
                            child: ClipOval(
                              child: Container(
                                color: Colors.orange,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 110,
                            left: 110,
                            child: ClipOval(
                              child: Container(
                                color: Colors.red,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 190,
                            right: 170,
                            child: ClipOval(
                              child: Container(
                                color: Colors.brown,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 95,
                            right: 110,
                            child: ClipOval(
                              child: Container(
                                color: Colors.black,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 45,
                            left: 45,
                            child: ClipOval(
                              child: Container(
                                color: Colors.cyan,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 45,
                            right: 45,
                            child: ClipOval(
                              child: Container(
                                color: Colors.yellow,
                                height: 20.0,
                                width: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // The rotating central image
                  ],
                ),
              ),
              SizedBox(height: circleSize * 0.15),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final random = Random();
                  return Stack(
                    children: [
                      // Main text (base layer)
                      const Text(
                        "Let's Start",
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Glitch layer 1 (red shift)
                      Transform.translate(
                        offset: Offset(
                          _randomOffset.value + random.nextInt(4) - 2,
                          _randomOffset.value + random.nextInt(4) - 2,
                        ),
                        child: Text(
                          "Let's Start",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.red.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Glitch layer 2 (blue shift)
                      Transform.translate(
                        offset: Offset(
                          _randomOffset.value - random.nextInt(4),
                          _randomOffset.value - random.nextInt(4),
                        ),
                        child: const Text(
                          "Let's Start",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: circleSize * 0.01),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 1500), // Smooth fade-in
              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 1500), // Smooth upward motion
                curve: Curves.easeOut, // Ease-out curve for natural motion
                transform: Matrix4.translationValues(0, _offsetY, 0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ), //this right here
                            child: SizedBox(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      controller: apiKey,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.api_sharp),
                                        suffixIcon: Icon(
                                          Icons.email,
                                        ),
                                        labelText: "Enter Api key",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        )),
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    TextField(
                                      controller: enteredToken,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.token),
                                        suffixIcon:
                                            Icon(Icons.remove_red_eye_sharp),
                                        labelText: "Enter token",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        )),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg: "Contact by support !!!");
                                          },
                                          child:
                                              const Text('Forget password?')),
                                    ),
                                    SizedBox(
                                      width: 320.0,
                                      child: ElevatedButton(
                                        style: button(),
                                        onPressed: () {
                                          if (apiKey.text == username &&
                                              enteredToken.text == password) {
                                            /*prefs.setString(
                                                  'apikey', username);
                                              prefs.setString(
                                                  'password', password);*/
                                            apiKey.text = "";
                                            enteredToken.text = "";
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  content: Text(
                                                      "Login successful",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Colors.white))),
                                            );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen()));
                                            setState(() {});
                                          } else {
                                            apiKey.text = "";
                                            enteredToken.text = "";
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  content: Text("Login failed",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Colors.white))),
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
                        });
                  },
                  style: button(),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

void _attachBlocObserver() {
  Bloc.observer = AppBlocObserver();
}

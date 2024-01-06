import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_project/Tasks.dart';

import 'Detail.dart';
import 'Project.dart';

void main() {
  runApp(const MyApp());
  /*runApp(MaterialApp(
    title: "List2",
    home: Scaffold(
      appBar: AppBar(
        title: const Text("First"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(100),
        child: Column(
          children: [
            text(),
            SizedBox(width: 12, height: 5),
            button(),
            SizedBox(width: 12, height: 5),
            //myList(),
          ],
        ),
      ),
    ),
  ));*/
}

Widget text() {
  var textFormField = TextFormField(
    decoration: const InputDecoration(
      border: UnderlineInputBorder(),
      labelText: 'Enter your username',
    ),
  );
  return textFormField;
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
//Widget myList() {}
/*Widget myList() {
  var list = ListView(
    // ignore: prefer_const_literals_to_create_immutables
    children: [
      ListTile(
        leading: Icon(Icons.access_alarm_outlined),
        title: Text("Alarm"),
        subtitle: Text("My time...."),
        trailing: Icon(Icons.add_moderator_outlined),
        onTap: () {
          Fluttertoast.showToast(msg: 'Hello world...');
          debugPrint("Hello World...");
        },
      ),
      ListTile(
        leading: Icon(Icons.access_alarm_outlined),
        title: Text("Alarm"),
        subtitle: Text("My time...."),
        trailing: Icon(Icons.accessibility_new),
        onTap: () {
          Fluttertoast.showToast(msg: 'Hello');
          debugPrint("Hello");
        },
      )
    ],
  );
b
  return list;
}*/

class MyApp extends StatelessWidget {
  //TextEditingController value = TextEditingController();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController val = TextEditingController();
  //TextEditingController subVal = TextEditingController();
  //late List data;
  List<Project> data = [];
  //List<String> subItem = [];

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
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Open project")),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: TextField(
                controller: val,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: "Enter value",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
                  //isDense: true,
                ),
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: subVal,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.dataset),
                labelText: "Enter sub value",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
                //isDense: true,
              ),
            ),
          ),*/
          ElevatedButton(
            onPressed: () {
              //getData();
              //item.add(val.text);
              //subItem.add(subVal.text);
              //Fluttertoast.showToast(msg: val.text);
              //val.clear();
              //subVal.clear();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TasksScreen()));
              setState(() {});
            },
            style: button(),
            child: Text(
              'Add now...',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.0),
            itemCount: data.length,
            itemBuilder: (BuildContext ctx, int index) {
              //return Text(item[index]);
              return ListTile(
                  title: Text(data[index].name),
                  subtitle: Text(data[index].id.toString()),
                  //tileColor: Color.fromARGB(255, 146, 105, 105),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        data.removeAt(index);
                        //subItem.removeAt(index);
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
    ));
  }
}

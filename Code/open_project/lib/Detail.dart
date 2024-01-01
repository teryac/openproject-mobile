import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Subjects.dart';

// ignore: must_be_immutable
class StateDetail extends StatefulWidget {
  int id;
  String name;

  StateDetail(this.id, this.name);

  @override
  State<StateDetail> createState() => Detail(id, name);
}

class Detail extends State<StateDetail> {
  String name;
  int id;
  List<Subjects> dataOfSubject = [];

  Detail(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    Uri uri =
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/work_packages");

    http.get(uri).then((response) {
      var jsonResponse = jsonDecode(response.body);
      var embedded = jsonResponse['_embedded'];
      var elements = embedded['elements'] as List;

      if (mounted) {
        setState(() {
          Iterable<Subjects> subjects = elements.map(
              (data) => Subjects(id: data['id'], subject: data['subject']));
          dataOfSubject = subjects.toList();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.0),
            itemCount: dataOfSubject.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ListTile(
                  title: Text(dataOfSubject[index].subject),
                  subtitle: Text(dataOfSubject[index].id.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                  onTap: () {});
            },
          )),
        ],
      ),

      /* Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          style: button(),
          child: Text(
            'Back...' + id.toString(),
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),*/
    );
  }

  ButtonStyle button() {
    ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 89, 142, 167),
      elevation: 0,
      minimumSize: Size(327, 50),
      padding: const EdgeInsets.symmetric(horizontal: 35),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );

    return raisedButtonStyle;
  }
}

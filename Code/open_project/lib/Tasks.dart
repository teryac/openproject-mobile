import 'package:flutter/material.dart';
import 'package:open_project/main.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => Tasks();
}

class Tasks extends State<TasksScreen> {
  String dropdwonvalue = 'In Progress';
  String personvalue = 'Shaaban Shaheen';
  TextEditingController desc = TextEditingController();

  Tasks({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
        children: [
          Text(
            "Type",
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(width: 15, height: 3),
          Text("Name of Task", style: TextStyle(fontSize: 19.0))
        ],
      )),
      body: Column(children: [
        //Start part 1
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: dropdwonvalue,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 3,
                color: Colors.black,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdwonvalue = newValue!;
                });
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                DropdownMenuItem<String>(
                  value: 'Two',
                  child: Text('Two'),
                ),
                DropdownMenuItem<String>(
                  value: 'Three',
                  child: Text('Three'),
                )
              ],
            ),
          ),
          const SizedBox(width: 33, height: 3),
          Column(children: [
            const Row(children: [
              Text("Create by:"),
              SizedBox(width: 8, height: 3),
              Text("Shaaban Shaheen"),
            ]),
            Row(children: [
              const Text("Last updates:"),
              const SizedBox(width: 8, height: 3),
              Text(
                  "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day} "),
              Text("${DateTime.now().hour}:${DateTime.now().minute} ")
            ]),
          ]),
        ]),
        //End part1
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: desc,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(15),
              )),
            ),
          ),
        ),
        //Start part 3
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "People:",
              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            ),
            Row(children: [
              const Text("Assignee:"),
              const SizedBox(width: 28, height: 0),
              DropdownButton<String>(
                value: personvalue,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 3,
                  color: Colors.black,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    personvalue = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Shaaban Shaheen',
                    child: Text('Shaaban Shaheen'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Yaman Kalaji',
                    child: Text('Yaman Kalaji'),
                  ),
                ],
              ),
            ]),
            Row(children: [
              const Text("Accountable:"),
              const SizedBox(width: 8, height: 0),
              DropdownButton<String>(
                value: personvalue,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 3,
                  color: Colors.black,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    personvalue = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Shaaban Shaheen',
                    child: Text('Shaaban Shaheen'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Yaman Kalaji',
                    child: Text('Yaman Kalaji'),
                  )
                ],
              ),
            ]),
          ]),
        ),
        //End part3
        //Start part4
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Estimates & Time',
                style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Estimated time:'),
              //const SizedBox(width: 28, height: 0),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 150),
                child: const TextField(
                  textAlign: TextAlign.start,
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    labelText: "Time",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    )),
                  ),
                ),
              ),
              //const Text('h'),
            ]),
          ]),
        ),
        //End part4
      ]),
    );
  }
}

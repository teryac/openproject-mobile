// ignore_for_file: file_names

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:open_project/Models/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProcessingTasks {
  List<Subjects> subjects = [];

  Future<List<Subjects>> getTask(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var apikey = prefs.getString('apikey');
    var token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    Response r = await get(
        Uri.parse("https://op.yaman-ka.com/api/v3/projects/$id/work_packages"),
        headers: <String, String>{'authorization': basicAuth});

    if (r.statusCode == 200) {
      var jsonResponse = jsonDecode(r.body);
      var embedded = jsonResponse['_embedded'];
      if (embedded != null) {
        var elements = embedded['elements'] as List;
        subjects = elements.map((data) {
          // Safely access the raw field
          String rawDescription =
              data['description']?['raw'] ?? 'No description available';
          String sub = data['subject'];

          int idTask = data['id'];
          String status =
              data['_links']?['status']?['title'] ?? 'No Status available';

          return Subjects(
              id: idTask,
              subject: sub,
              description: rawDescription,
              status: status);
        }).toList();
        return subjects;
      }
    } else {
      throw Exception("Failed to load projects. Status code: ${r.statusCode}");
    }
    return subjects;
  }

  void deleteTask(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var apikey = prefs.getString('apikey');
    var token = prefs.getString('password');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apikey:$token'))}';

    await http.delete(
      Uri.parse("https://op.yaman-ka.com/api/v3/work_packages/$id"),
      headers: <String, String>{
        'content-type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },
    ).then((response) {
      if (response.statusCode == 204) {
        Fluttertoast.showToast(msg: 'task of $id has been deleted');
      } else {
        Fluttertoast.showToast(msg: 'you cannot delete task of $id');
      }
    });
  }
}

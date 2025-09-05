import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProToken {
  String? getToken;
  String apiKey = 'apikey';

  void checkToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('apikey', apiKey);
    String? server = prefs.getString('server');
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$apiKey:$token'))}';

    Response r = await get(Uri.parse('$server/api/v3/projects'),
        headers: <String, String>{'authorization': basicAuth});
    if (r.statusCode == 200) {
      await prefs.setString('password', token);
      getToken = prefs.getString('password');
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
          fontSize: 20,
          backgroundColor: Colors.green);
    } else {
      Fluttertoast.showToast(
          msg: 'You don\'t sign up',
          textColor: Colors.white,
          fontSize: 20,
          backgroundColor: Colors.red);
    }
  }
}

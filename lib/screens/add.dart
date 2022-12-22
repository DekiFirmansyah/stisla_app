import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stisla/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stisla/models/loginError.dart';
import 'package:stisla/models/token.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController nameController = TextEditingController();
  void addData() async {
    //request add
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    Map body = {
      'name': nameController.text,
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/categories'),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Home()));
    } else {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      // print(loginError.errors?.email?.elementAt(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Screen'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    addData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(210, 52, 250, 38),
                  ),
                  child: const Text("Tambah Data"),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
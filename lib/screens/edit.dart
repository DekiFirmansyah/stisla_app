import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stisla/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stisla/models/loginError.dart';
import 'package:stisla/models/token.dart';

class Edit extends StatefulWidget {
  final int id;
  final String category;
  const Edit({super.key, required this.id, required this.category});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    setState(() {
      nameController.text = widget.category;
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void editData(id) async {
    //request add
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    Map body = {
      'name': nameController.text,
    };
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/categories/$id'),
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
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

  void deleteData(id) async {
    //request add
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.delete(
      Uri.parse('http://192.168.1.20:8000/api/categories/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 204) {
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
        title: const Text('Edit Screen'),
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
                width: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          editData(widget.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 52, 38, 250),
                        ),
                        child: const Text("Edit Data"),
                      ),
                    ),
                    Container(
                      width: 50,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          deleteData(widget.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 250, 38, 38),
                        ),
                        child: const Text("Delete Data"),
                      ),
                    ),
                  ],
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
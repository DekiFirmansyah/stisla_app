import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:stisla/components/background.dart';
import 'package:stisla/models/loginError.dart';
import 'package:stisla/models/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  bool isLoggedIn = false;
  bool isLoginInProgress = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "REGISTER",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2661FA),
                  fontSize: 36,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            // Text Name
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
            ),
            // Text Email
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
            ),
            // Text Password
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
            ),
            // Text Password Confirmation
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passwordConfirmationController,
                decoration: const InputDecoration(
                  labelText: "Password Confirmation",
                ),
                obscureText: true,
              ),
            ),
            // Button Sign Up
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoginInProgress = true;
                  });
                  //request login
                  Map<String, String> headers = {"Accept": "application/json"};
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:8000/api/auth/register'),
                    headers: headers,
                    body: {
                      'name': nameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      // 'device_name': 'android',
                    },
                  );
                  print(response.body);
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    final token = Token.fromJson(jsonResponse);
                    final prefs = await SharedPreferences.getInstance();
                    print("Token From Api ${token.token}");
                    if (token.token != null) {
                      await prefs.setString('token', token.token!);
                      setState(() {
                        isLoginInProgress = false;
                        isLoggedIn = true;
                      });

                      if (!mounted) {
                        return;
                      }

                      if (isLoggedIn) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    }
                  } else {
                    final jsonResponse = json.decode(response.body);
                    final loginError = LoginError.fromJson(jsonResponse);
                    // print(loginError.message);
                    // print(loginError.errors?.email?.elementAt(0));
                    setState(() {
                      isLoginInProgress = false;
                      isLoggedIn = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 255, 136, 34),
                      Color.fromARGB(255, 255, 177, 41),
                    ]),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: const Text(
                    "SIGN UP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Page Sign In
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(children: [
                const Text("Already Have an Account?"),
                InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: const Text(" Sign In"))
              ]),
            ),
            Visibility(
              visible: isLoginInProgress,
              child: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
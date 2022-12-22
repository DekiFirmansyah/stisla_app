import 'package:flutter/material.dart';
import 'package:stisla/network/api.dart';
import 'dart:convert';
import 'package:stisla/models/loginError.dart';
import 'package:stisla/models/token.dart';
import 'package:stisla/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//   var email, password;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _secureText = true;

//   showHide() {
//     setState(() {
//       _secureText = !_secureText;
//     });
//   }

//   _showMsg(msg) {
//     final snackBar = SnackBar(
//       content: Text(msg),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Color(0xff151515),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 28, vertical: 72),
//           child: Column(
//             children: [
//               Card(
//                 elevation: 4.0,
//                 color: Colors.white,
//                 margin: EdgeInsets.only(top: 86),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(24),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Login",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 18),
//                         TextFormField(
//                             cursorColor: Colors.blue,
//                             keyboardType: TextInputType.text,
//                             decoration: InputDecoration(
//                               hintText: "Email",
//                             ),
//                             validator: (emailValue) {
//                               if (emailValue!.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               email = emailValue;
//                               return null;
//                             }),
//                         SizedBox(height: 12),
//                         TextFormField(
//                             cursorColor: Colors.blue,
//                             keyboardType: TextInputType.text,
//                             obscureText: _secureText,
//                             decoration: InputDecoration(
//                               hintText: "Password",
//                               suffixIcon: IconButton(
//                                 onPressed: showHide,
//                                 icon: Icon(_secureText
//                                     ? Icons.visibility_off
//                                     : Icons.visibility),
//                               ),
//                             ),
//                             validator: (passwordValue) {
//                               if (passwordValue!.isEmpty) {
//                                 return 'Please enter your password';
//                               }
//                               password = passwordValue;
//                               return null;
//                             }),
//                         SizedBox(height: 12),
//                         TextButton(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 18, vertical: 10),
//                             child: Text(
//                               _isLoading ? 'Proccessing..' : 'Login',
//                               textDirection: TextDirection.ltr,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18.0,
//                                 decoration: TextDecoration.none,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ),
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               _login();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Does'nt have an account? ",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushReplacementNamed(context, '/register');
//                     },
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                         decoration: TextDecoration.none,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//     });
//     var data = {'email': email, 'password': password, 'device_name': 'mobile'};

//     http.Response res = await Network().auth(data, '/login');
//     print(res.statusCode);
//     var body = json.decode(res.body);
//     if (body['success']) {
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.setString('token', json.encode(body['token']));
//       localStorage.setString('user', json.encode(body['user']));
//       Navigator.pushReplacement(
//         context,
//         new MaterialPageRoute(builder: (context) => Home()),
//       );
//     } else {
//       _showMsg(body['message']);
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoggedIn = false;
  bool isLoginInProgress = false;

  //email controller
  final TextEditingController _emailController =
      TextEditingController(text: "superadmin@gmail.com");
  //password controller
  final TextEditingController _passwordController =
      TextEditingController(text: "password");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2661FA),
                  fontSize: 36,
                ),
                textAlign: TextAlign.left,
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
                controller: _emailController,
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
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
            ),
            // Button Login
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
                    Uri.parse('http://10.0.2.2:8000/api/auth/login'),
                    headers: headers,
                    body: {
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'device_name': 'android',
                    },
                  );
                  if (response.statusCode == 200) {
                    final jsonResponse = json.decode(response.body);
                    final token = Token.fromJson(jsonResponse);
                    final prefs = await SharedPreferences.getInstance();
                    print("Token From Api ${token.token}");
                    if (token.token != null) {
                      // await prefs.setString(
                      //     'token', jsonDecode(response.body)['token']);
                      await prefs.setString('token', token.token!);
                      setState(() {
                        isLoginInProgress = false;
                        isLoggedIn = true;
                      });

                      if (!mounted) {
                        return;
                      }

                      if (isLoggedIn) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Home()));
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
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Page Sign Up
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                children: [
                  const Text("Belum punya akun?"),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: const Text(" Sign Up"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
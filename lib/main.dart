// import 'package:flutter/material.dart';
// import 'screens/home.dart';
// import 'screens/login.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CheckAuth(),
//     );
//   }
// }

// class CheckAuth extends StatefulWidget{
//   @override
//   _CheckAuthState createState() => _CheckAuthState();
// }

// class _CheckAuthState extends State<CheckAuth>{
//   bool isAuth = false;

//   @override
//   void initState(){
//     super.initState();
//     _checkIfLoggedIn();
//   }

//   void _checkIfLoggedIn() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     //localStorage.clear();
//     var token = localStorage.getString('token');
//     if(token != null){
//       if(mounted){
//         setState(() {
//           isAuth = true;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context){
//     Widget child;
//     if(isAuth){
//       child = HomePage();
//     } else{
//       child = Login();
//     }

//     return Scaffold(
//       body: child,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:stisla/screens/home.dart';
import 'package:stisla/screens/login.dart';
import 'package:stisla/screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'laravel9-starter-stisla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => const Home(),
        '/register': (context) => const Register(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stisla/network/api.dart';
import 'package:stisla/models/categories.dart';
import 'package:stisla/screens/add.dart';
import 'package:stisla/screens/edit.dart';
import 'package:stisla/screens/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   String name = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   _loadUserData() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var user = jsonDecode(localStorage.getString('user'));

//     if (user != null) {
//       setState(() {
//         name = user['email'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('Home'),
//         backgroundColor: Colors.yellow,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.power_settings_new),
//             onPressed: () {
//               logout();
//             },
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.all(15),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     'Hello, ',
//                     style: TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                   Text(
//                     '${name}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future <void> logout() async {
//     http.Response res = await Network().getData('/logout');
//     print(res.statusCode);
//     var body = json.decode(res.body);
//     if (body['success'] == null) {
//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.remove('user');
//       localStorage.remove('token');
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Login()));
//     }
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var categoryList = <Category>[];

  Future<List<Category>?> getList() async {
    final prefs = await _prefs;
    var token = prefs.getString('token');
    print(token);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      var url = Uri.parse("http://10.0.2.2:8000:8000/api/categories");

      final response = await http.get(url, headers: headers);

      print(response.statusCode);
      print(categoryList.length);
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        var jsonString = response.body;
        return categoryFromJson(jsonString);
      }
    } catch (error) {
      print('Testing');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Add()));
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "List Categories",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 36,
                ),
              ),
            ),
            FutureBuilder<List<Category>?>(
              future: getList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].name),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Edit(
                                            id: snapshot.data![index].id,
                                            category:
                                                snapshot.data![index].name,
                                          )));
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              // width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  //request logout
                  final pref = await SharedPreferences.getInstance();
                  final token = pref.getString('token');

                  final logoutRequest = await http.post(
                    Uri.parse('http://192.168.1.20:8000/api/auth/logout'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                  );
                  if (!mounted) return;
                  if (logoutRequest.statusCode == 200) {
                    print("logout success");
                    //logout success
                    pref.clear();
                    //navigate to login page
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.bottomLeft,
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
                      Color.fromARGB(255, 27, 216, 250),
                      Color.fromARGB(255, 65, 23, 251),
                    ]),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: const Text(
                    "LOGOUT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

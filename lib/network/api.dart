import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class Network {
//   final String _url = 'http://10.0.2.2:8000/api/auth';
//   // 192.168.1.2 is my IP, change with your IP address
//   var token;

//   _getToken() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     token = jsonDecode(localStorage.getString('token'))['token'];
//   }

//   auth(data, apiURL) async {
//     var fullUrl = _url + apiURL;
//     return await http.post(fullUrl,
//         body: jsonEncode(data), headers: _setHeaders());
//   }

//   getData(apiURL) async {
//     var fullUrl = _url + apiURL;
//     await _getToken();
//     return await http.get(
//       fullUrl,
//       headers: _setHeaders(),
//     );
//   }

//   _setHeaders() => {
//         'Content-type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       };
// }

class HttpService {
  static final String baseUrl = 'http://10.0.2.2:8000/api';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'auth/login';
  final String logout = 'auth/logout';
  final String categories = '/categories';
}
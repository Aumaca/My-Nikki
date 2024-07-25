import 'package:my_nikki/utils/requests.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<Map<String, dynamic>?> getUser() async {
  Response response = await genericGet('/user/getUser', isAuthenticated: true);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data['user'];
  }
  return null;
}

import 'package:logger/logger.dart';
import 'package:my_nikki/utils/requests.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<Map<String, dynamic>?> getUser() async {
  Response response = await genericGet('/user/getUser', isAuthenticated: true);
  if (response.statusCode == 200) {
    try {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      Logger().e("Error decoding JSON: $e");
    }
  } else {
    Logger().w("Request failed with status: ${response.statusCode}");
  }
  return null;
}

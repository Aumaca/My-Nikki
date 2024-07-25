import 'package:my_nikki/utils/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import "dart:convert";

SecureStorage storage = SecureStorage();

Future<bool> isTokenValid() async {
  String? token = await SecureStorage().readToken();
  if (token != null) {
    Response response =
        await genericPost('/auth/check_token', {"token": token});
    if (response.statusCode == 200) {
      return true;
    } else {
      await storage.deleteToken();
      return false;
    }
  }
  return false;
}

Future<Response> genericGet(String path, {bool isAuthenticated = false}) async {
  try {
    String? token = await storage.readToken();
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (isAuthenticated) {
      headers['Authorization'] = "Bearer $token";
    }

    var url = Uri.parse("${dotenv.get('BACKEND_URL')}$path");
    var response = await http.get(
      url,
      headers: headers,
    );

    return response;
  } catch (e) {
    throw Exception("Error making request: $e");
  }
}

Future<Response> genericPost(String path, Map<String, dynamic> data,
    {bool isAuthenticated = false}) async {
  try {
    String? token = await storage.readToken();
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (isAuthenticated) {
      headers['Authorization'] = token!;
    }

    var url = Uri.parse("${dotenv.get('BACKEND_URL')}$path");
    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    return response;
  } catch (e) {
    throw Exception("Error making request: $e");
  }
}

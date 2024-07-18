import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_nikki/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

Future<bool> isTokenValid() async {
  SecureStorage storage = SecureStorage();
  final token = await storage.readToken();
  if (token != null) {
    var url = Uri.parse("${dotenv.get('BACKEND_URL')}/auth/checkToken");
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(token),
    );

    return response.statusCode == 200 ? true : false;
  }
  return false;
}

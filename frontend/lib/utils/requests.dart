import 'package:logger/logger.dart';
import 'package:my_nikki/utils/media.dart';
import 'package:my_nikki/utils/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
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
    {bool isAuthenticated = false, List<XFile>? files}) async {
  try {
    String? token = await storage.readToken();

    Map<String, String> headers = {};
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (isAuthenticated) {
      headers['Authorization'] = "Bearer $token";
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

Future<Response> genericPostEntryRequest(String path, Map<String, dynamic> data,
    {bool isAuthenticated = false, List<XFile>? files}) async {
  try {
    String? token = await storage.readToken();
    Map<String, String> headers = {};

    if (isAuthenticated) {
      headers['Authorization'] = "Bearer $token";
    }

    var url = Uri.parse("${dotenv.get('BACKEND_URL')}$path");
    var request = http.MultipartRequest("POST", url);

    request.fields['data'] = jsonEncode(data);

    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();
        var multipartFile = http.MultipartFile(
          'media',
          stream,
          length,
          filename: basename(file.path),
        );
        request.files.add(multipartFile);
      }
    }

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  } catch (e) {
    throw Exception("Error making request: $e");
  }
}

String getImage(String filename) {
  return "${dotenv.get('BACKEND_URL')}/uploads/$filename";
}

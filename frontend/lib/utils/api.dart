import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_nikki/utils/secure_storage.dart';

/// Return 200 OK if user is ok
///
/// Return 201 CREATED if user was signed up or hasn't completed his profile
Future<int> handleGoogleAuth(UserCredential userCredential) async {
  Map<String, dynamic> userData = {
    'uid': userCredential.user?.uid,
    'email': userCredential.user?.email,
    'isNewUser': userCredential.additionalUserInfo?.isNewUser,
    'photoURL': userCredential.user?.photoURL,
    'displayName': userCredential.user?.displayName,
  };

  var url = Uri.parse("${dotenv.get('BACKEND_URL')}/auth/google");
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(userData));

  final Map<String, dynamic> responseData = json.decode(response.body);

  if (responseData.containsKey('token')) {
    bool tokenSaved = await SecureStorage().writeToken(responseData['token']);
    if (tokenSaved) {
      return 200;
    } else {
      return 0; // If return 0, there's a serious problem, I think
    }
  } else {
    return 201;
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> writeToken(String token) async {
    try {
      await storage.write(key: "jwt_token", value: token);
      return true;
    } catch (e) {
      Logger().e("Error writing token.", error: e);
      return false;
    }
  }

  Future<String?> readToken() async {
    try {
      String? value = await storage.read(key: "jwt_token");
      return value;
    } catch (e) {
      Logger().e("Error reading token.", error: e);
      return "";
    }
  }

  Future<void> deleteToken() async {
    try {
      await storage.delete(key: "jwt_token");
    } catch (e) {
      Logger().e("Error deleting token.", error: e);
    }
  }
}

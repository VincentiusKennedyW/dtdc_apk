import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String tokenKey = "auth_token";

  // Get the stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: tokenKey);
  }

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: tokenKey, value: token);
  }

  // Remove token (for logging out)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: tokenKey);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }
}

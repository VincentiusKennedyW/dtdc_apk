import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtdc/model/User.dart';
import 'package:dtdc/utils/auth.dart';
import '../config.dart';

class UserRepository {
  // API base URL
  final String baseUrl = Config.apiUrl;

  // Register user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    print('$baseUrl/register');
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body
      return true;
    } else {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  // Login user and store token
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Parse response and get the token
      final responseData = jsonDecode(response.body);
      String token = responseData['data']['token'];

      Auth().setToken(token);

      return true;
    } else {
      throw Exception('${jsonDecode(response.body)['message']}');
    }
  }

  // Verify user (for example, with OTP or email verification)
  Future<User> getUser({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)['data']);
    } else {
      return User.fromJson({});
    }
  }
}

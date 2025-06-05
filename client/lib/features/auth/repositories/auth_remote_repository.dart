import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:8080/v1/auth/signup"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (res.statusCode != 201) throw Exception(res.body);
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      print("Error during sign up: $e");
      throw "";
    }
  }

  static Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:8080/v1/auth/signin"),
        headers: {"content-type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print(res.body);
      print(res.statusCode);
    } catch (e) {
      print("Error during sign in: $e");
    }
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:dialisaku/models/authenticaiton_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final String _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final String _endPointLogin;
  late final String _endPointRegister;
  static const String _tokenKey = 'auth_token';

  AuthenticationService() {
    _endPointLogin = '$_baseUrl/login';
    _endPointRegister = '$_baseUrl/register';
  }

  Future<void> saveLoginState(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<LoginResponse> fetchLogin({
    required String nik,
    required String password,
  }) async {
    try {
      final loginResquest = LoginRequest(nik: nik, password: password);
      log('==================Service Login Request================');
      final requestBody = jsonEncode(loginResquest.toJson());
      log(requestBody);
      final response = await http.post(
        Uri.parse(_endPointLogin),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      log('=================Service Login Response===============');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);
        if (loginResponse.accessToken != null) {
          await saveLoginState(loginResponse.accessToken!);
        }
        return loginResponse;
      } else {
        // Handle non-200 responses as server errors
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
  }

  Future<void> logout() async {
    await clearLoginState();
  }

  Future<RegisterResponse> fetchRegister({
    required String nik,
    required String name,
    required String jenisKelamin,
    required String umur,
    required String pendidikan,
    required String alamat,
    required String bbAwal,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final registerRequest = RegisterRequest(
        nik: nik,
        name: name,
        jenisKelamin: jenisKelamin,
        umur: umur,
        pendidikan: pendidikan,
        alamat: alamat,
        bbAwal: bbAwal,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      log('==================Service Register Request================');
      final requestBody = jsonEncode(registerRequest.toJson());
      log(requestBody);
      final response = await http.post(
        Uri.parse(_endPointRegister),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );
      log('=================Service Register Response===============');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Assuming register also follows a similar pattern, though not specified

        return RegisterResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal mengambi data: ${response.statusCode}');
      }
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
  }
}

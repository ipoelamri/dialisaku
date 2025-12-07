// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/authenticaiton_models.dart';

// class AuthenticationService {
//   static final String baseUrl =
//       dotenv.env['url_emu'] ?? 'http://localhost:8000';
//   static final String _registerEndpoint = '$baseUrl/register';
//   static final String _loginEndpoint = '$baseUrl/login';

//   // =====================================================
//   // REGISTER
//   // =====================================================
//   Future<RegisterResponse> register(RegisterRequest request) async {
//     try {
//       final url = Uri.parse(_registerEndpoint);

//       // DEBUG REQUEST
//       print("======= REGISTER REQUEST =======");
//       print("URL: $url");
//       print(
//         "Headers: {Content-Type: application/json, Accept: application/json}",
//       );
//       print("Body: ${jsonEncode(request.toJson())}");

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode(request.toJson()),
//       );

//       // DEBUG RESPONSE
//       print("======= REGISTER RESPONSE =======");
//       print("Status code: ${response.statusCode}");
//       print("Request: ${response.request}");
//       print("Body: ${response.body}");

//       // HANDLE NON-200
//       if (response.statusCode != 200 && response.statusCode != 201) {
//         throw Exception(
//           'Failed to register: ${response.statusCode} - ${response.body}',
//         );
//       }

//       // HANDLE EMPTY / INVALID JSON
//       if (response.body.isEmpty) {
//         throw Exception("Register response kosong");
//       }

//       dynamic json;
//       try {
//         json = jsonDecode(response.body);
//       } catch (e) {
//         throw Exception("Register response bukan JSON valid: ${response.body}");
//       }

//       return RegisterResponse.fromJson(json);
//     } catch (e) {
//       throw Exception('Register error: $e');
//     }
//   }

//   // =====================================================
//   // LOGIN
//   // =====================================================
//   Future<LoginResponse> login(LoginRequest request) async {
//     try {
//       final url = Uri.parse(_loginEndpoint);

//       // DEBUG REQUEST
//       print("======= LOGIN REQUEST =======");
//       print("URL: $url");
//       print(
//         "Headers: {Content-Type: application/json, Accept: application/json}",
//       );
//       print("Body: ${jsonEncode(request.toJson())}");

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode(request.toJson()),
//       );

//       // DEBUG RESPONSE
//       print("======= LOGIN RESPONSE =======");
//       print("Status code: ${response.statusCode}");
//       print("Request: ${response.request}");
//       print("Body: ${response.body}");

//       // ERROR jika bukan 200
//       if (response.statusCode != 200) {
//         throw Exception(
//           'Failed to login: ${response.statusCode} - ${response.body}',
//         );
//       }

//       // HANDLE EMPTY / INVALID JSON
//       if (response.body.isEmpty) {
//         throw Exception("Login response kosong");
//       }

//       dynamic json;
//       try {
//         json = jsonDecode(response.body);
//       } catch (e) {
//         throw Exception("Login response bukan JSON valid: ${response.body}");
//       }

//       return LoginResponse.fromJson(json);
//     } catch (e) {
//       throw Exception('Login error: $e');
//     }
//   }
// }

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:dialisaku/models/authenticaiton_models.dart';

class AuthenticationService {
  final String _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final String _endPointLogin;
  late final String _endPointRegister;

  AuthenticationService() {
    _endPointLogin = '$_baseUrl/login';
    _endPointRegister = '$_baseUrl/register';
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
        return LoginResponse.fromJson(jsonResponse);
      } else {
        // Handle non-200 responses as server errors
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
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

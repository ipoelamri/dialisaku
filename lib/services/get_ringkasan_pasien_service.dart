import 'package:dialisaku/models/get_ringkasan_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class GetRingkasanPasienService {
  final String _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final String _endPointGetRingkasan;

  GetRingkasanPasienService() {
    _endPointGetRingkasan = '$_baseUrl/monitoring/ringkasan';
  }

  Future<ModelGetRingkasanResponse> fetchGetRingkasan(String token) async {
    try {
      log('=================Service GetRingkasanPasien Request===============');
      final response = await http.get(
        Uri.parse(_endPointGetRingkasan),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log(response.request.toString());

      log(
        '=================Service GetRingkasanPasien Response===============',
      );
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ModelGetRingkasanResponse.fromJson(jsonResponse);
      } else {
        // Handle non-200 responses as server errors
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
  }
}

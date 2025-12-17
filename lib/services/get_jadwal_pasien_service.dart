import 'dart:io';

import 'package:dialisaku/models/get_jadwal_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class GetJadwalPasienService {
  final String _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final String _endPointGetJadwal;

  GetJadwalPasienService() {
    _endPointGetJadwal = '$_baseUrl/jadwal';
  }

  Future<ModelGetJadwalResponse> fetchGetJadwal(String token) async {
    try {
      log('=================Service GetJadwalPasien Request===============');
      final response = await http.get(
        Uri.parse(_endPointGetJadwal),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log(response.request.toString());

      log('=================Service GetJadwalPasien Response===============');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ModelGetJadwalResponse.fromJson(jsonResponse);
      } else {
        // Handle non-200 responses as server errors
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      log('gagal menghubungi server - SocketException', error: e);
      throw Exception(
          'Tidak ada koneksi internet. Silakan periksa koneksi Anda.');
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
  }
}

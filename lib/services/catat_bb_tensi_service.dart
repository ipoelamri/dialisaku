import 'dart:io';

import 'package:dialisaku/models/catat_bb_tensi_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class CatatBbTensiService {
  final _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final _endPointCatatBbTensi;

  CatatBbTensiService() {
    _endPointCatatBbTensi = '$_baseUrl/monitoring/tekanan-darah';
  }

  Future<CatatBbTensiModelResponse> fetchCatatBbTensi({
    required String token,
    required int tekananDarahSistol,
    required int tekananDarahDiastol,
    required int beratBadanTerukur,
  }) async {
    try {
      final catatBbTensiModelRequest = CatatBbTensiModelRequest(
        tekananDarahSistol: tekananDarahSistol,
        tekananDarahDiastol: tekananDarahDiastol,
        beratBadanTerukur: beratBadanTerukur,
      );
      log('=====================Request CatatBbTensi=====================');
      final requestBody = jsonEncode(catatBbTensiModelRequest.toJson());
      log(requestBody);
      log(token);
      final response = await http.post(
        Uri.parse(_endPointCatatBbTensi),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      log('=====================Response CatatBbTensi=====================');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CatatBbTensiModelResponse.fromJson(jsonResponse);
      } else {
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

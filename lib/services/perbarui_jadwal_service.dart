import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:dialisaku/models/perbarui_jadwal_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PerbaruiJadwalService {
  final _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final _endPointPerbaruiJadwal;

  PerbaruiJadwalService() {
    _endPointPerbaruiJadwal = '$_baseUrl/jadwal';
  }

  Future<PerbaruiJadwalModelResponse> perbaruiJadwal({
    required String token,
    required PerbaruiJadwalModelRequest request,
  }) async {
    try {
      log('=================Service PerbaruiJadwal Request===============');
      final requestBody = jsonEncode(request.toJson());
      log(requestBody);
      final response = await http.put(
        Uri.parse(_endPointPerbaruiJadwal),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );
      log('=================Service PerbaruiJadwal Response===============');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return PerbaruiJadwalModelResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal memperbarui jadwal: ${response.statusCode}');
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

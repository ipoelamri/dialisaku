import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:dialisaku/models/catat_makan_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CatatMakanService {
  final _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final _endPointCatatMakan;

  CatatMakanService() {
    _endPointCatatMakan = '$_baseUrl/monitoring/makan';
  }

  Future<CatatMakanModelResponse> fetchCatatMakan({
    required String token,
    required String waktuMakan,
    String? keteranganMakan,
  }) async {
    try {
      final catatMakanModelRequest = CatatMakanModelRequest(
        waktuMakan: waktuMakan,
        keteranganMakan: keteranganMakan,
      );

      log('=================Service CatatMakan Request===============');
      final requestBody = jsonEncode(catatMakanModelRequest.toJson());
      log(requestBody);
      final response = await http.post(
        Uri.parse(_endPointCatatMakan),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );
      log('=================Service CatatMakan Response===============');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CatatMakanModelResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
  }
}

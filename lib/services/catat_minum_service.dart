import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dialisaku/models/catat_minum_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CatatMinumService {
  final _baseUrl = dotenv.env['url_emu'] ?? 'http://localhost:8000';
  late final _endPointCatatMinum;

  CatatMinumService() {
    _endPointCatatMinum = '$_baseUrl/monitoring/minum';
  }

  Future<CatatMinumModelResponse> fetchCatatMinum({
    required String token,
    required String waktuMinum,
    required String jumlahMl,
    required String jenisCairan,
  }) async {
    try {
      final catatMinumModelRequest = CatatMinumModelRequest(
        waktuMinum: waktuMinum,
        jumlahMl: jumlahMl,
        jenisCairan: jenisCairan,
      );
      log('=====================Request CatatMinum=====================');
      final requestBody = jsonEncode(catatMinumModelRequest.toJson());
      log(requestBody);
      log(token);
      final response = await http.post(
        Uri.parse(_endPointCatatMinum),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      log('=====================Response CatatMinum=====================');
      log('Status Code: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CatatMinumModelResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      log('gagal menghubungi server', error: e);
      rethrow;
    }
  }
}

import 'package:dialisaku/models/get_ringkasan_model.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/services/get_ringkasan_pasien_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_ringkasan_pasien_provider.g.dart';

@riverpod
Future<ModelGetRingkasanResponse> getRingkasanPasien(
  GetRingkasanPasienRef ref,
) async {
  // Get the authentication details from the Auth provider
  final authData = ref.watch(authProvider).value;
  final token = authData?.accessToken;

  // If there's no token, the user is not logged in.
  if (token == null || token.isEmpty) {
    throw Exception('User is not authenticated.');
  }

  // Create the service and fetch the data
  final ringkasanService = GetRingkasanPasienService();
  final ringkasanResponse = await ringkasanService.fetchGetRingkasan(token);

  return ringkasanResponse;
}

import 'dart:async';
import 'dart:developer';
import 'package:dialisaku/models/perbarui_jadwal_model.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/services/perbarui_jadwal_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'perbarui_jadwal_provider.g.dart';

@riverpod
PerbaruiJadwalService perbaruiJadwalService(PerbaruiJadwalServiceRef ref) {
  return PerbaruiJadwalService();
}

@riverpod
class PerbaruiJadwalController extends _$PerbaruiJadwalController {
  @override
  FutureOr<PerbaruiJadwalModelResponse?> build() async {
    return null;
  }

  Future<void> perbaruiJadwal({
    required PerbaruiJadwalModelRequest request,
  }) async {
    state = const AsyncLoading();
    try {
      final authData = ref.read(authProvider).value;
      final token = authData?.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('User is not authenticated.');
      }

      final perbaruiJadwalService = ref.read(perbaruiJadwalServiceProvider);
      final perbaruiJadwalResponse = await perbaruiJadwalService.perbaruiJadwal(
        token: token,
        request: request,
      );

      state = AsyncData(perbaruiJadwalResponse);
    } catch (e, st) {
      log('perbarui jadwal error: $e', stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}

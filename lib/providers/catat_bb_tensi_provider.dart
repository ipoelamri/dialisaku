import 'dart:async';
import 'dart:developer';

import 'package:dialisaku/models/catat_bb_tensi_model.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/services/catat_bb_tensi_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catat_bb_tensi_provider.g.dart';

@riverpod
CatatBbTensiService catatBbTensiService(CatatBbTensiServiceRef ref) {
  return CatatBbTensiService();
}

@riverpod
class CatatBbTensiController extends _$CatatBbTensiController {
  @override
  FutureOr<CatatBbTensiModelResponse?> build() {
    return null;
  }

  Future<void> catatBbTensi({
    required int tekananDarahDiastol,
    required int tekananDarahSistol,
    required int beratBadanTerukur,
  }) async {
    state = const AsyncLoading();
    try {
      final authData = ref.read(authProvider).value;
      final token = authData?.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('User is not authenticated.');
      }

      final catatBbTensiService = ref.read(catatBbTensiServiceProvider);
      final response = await catatBbTensiService.fetchCatatBbTensi(
        token: token,
        tekananDarahSistol: tekananDarahSistol,
        tekananDarahDiastol: tekananDarahDiastol,
        beratBadanTerukur: beratBadanTerukur,
      );
      state = AsyncData(response);
    } catch (e, st) {
      log('catat BB & Tensi error: $e', stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}

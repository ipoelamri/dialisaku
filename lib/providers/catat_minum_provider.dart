import 'dart:async';
import 'dart:developer';
import 'package:dialisaku/models/catat_minum_model.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/services/catat_Minum_service.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catat_minum_provider.g.dart';

@riverpod
CatatMinumService catatMinumService(CatatMinumServiceRef ref) {
  return CatatMinumService();
}

@riverpod
class CatatMinumController extends _$CatatMinumController {
  @override
  FutureOr<CatatMinumModelResponse?> build() async {
    return null;
  }

  Future<void> catatMinum({
    required String waktuMinum,
    required String jumlahMl,
    required String jenisCairan,
  }) async {
    state = const AsyncLoading();
    try {
      final authData = ref.read(authProvider).value;
      final token = authData?.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('User is not authenticated.');
      }

      final catatMinumService = ref.read(catatMinumServiceProvider);
      final catatMinumResponse = await catatMinumService.fetchCatatMinum(
        token: token,
        waktuMinum: waktuMinum,
        jumlahMl: jumlahMl,
        jenisCairan: jenisCairan,
      );

      state = AsyncData(catatMinumResponse);
    } catch (e, st) {
      log('catat Minum error: $e', stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}

import 'dart:async';
import 'dart:developer';
import 'package:dialisaku/models/catat_makan_model.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/services/catat_makan_service.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catat_makan_provider.g.dart';

@riverpod
CatatMakanService catatMakanService(CatatMakanServiceRef ref) {
  return CatatMakanService();
}

@riverpod
class CatatMakanController extends _$CatatMakanController {
  @override
  FutureOr<CatatMakanModelResponse?> build() {
    return null;
  }

  Future<void> catatMakan({
    required String waktuMakan,
    String? keteranganMakan,
  }) async {
    state = const AsyncLoading();
    try {
      final authData = ref.read(authProvider).value;
      final token = authData?.accessToken;

      if (token == null || token.isEmpty) {
        throw Exception('User is not authenticated.');
      }

      final catatMakanService = ref.read(catatMakanServiceProvider);
      final catatMakanResponse = await catatMakanService.fetchCatatMakan(
        token: token,
        waktuMakan: waktuMakan,
        keteranganMakan: keteranganMakan,
      );

      state = AsyncData(catatMakanResponse);
    } catch (e, st) {
      log('catat makan error: $e', stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}

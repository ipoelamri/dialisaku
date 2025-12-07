import 'dart:async';
import 'dart:developer';

import 'package:dialisaku/models/authenticaiton_models.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/services/authentication_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_provider.g.dart';

@riverpod
AuthenticationService authService(AuthServiceRef ref) {
  return AuthenticationService();
}

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<RegisterResponse?> build() {
    // The build method should return the initial state.
    // Here, null indicates that no registration attempt has been made yet.
    return null;
  }

  Future<void> register({
    required String nik,
    required String name,
    required String jenisKelamin,
    required String umur,
    required String pendidikan,
    required String alamat,
    required String bbAwal,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final registerResponse = await authService.fetchRegister(
        nik: nik,
        name: name,
        jenisKelamin: jenisKelamin,
        umur: umur,
        pendidikan: pendidikan,
        alamat: alamat,
        bbAwal: bbAwal,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // If registration is successful, create a LoginResponse from the RegisterResponse
      // to store the full authentication details (including the token) in the central provider.
      if (registerResponse.accessToken != null && registerResponse.data != null) {
        final loginResponse = LoginResponse(
          status: registerResponse.status,
          message: registerResponse.message,
          data: registerResponse.data,
          accessToken: registerResponse.accessToken,
          tokenType: registerResponse.tokenType,
        );
        ref.read(authProvider.notifier).setAuth(loginResponse);
      }
      
      // Finally, set the state to the response of the registration attempt.
      state = AsyncData(registerResponse);

    } catch (e, st) {
      log('register error: $e', stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}
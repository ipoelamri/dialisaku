import 'dart:async';
import 'dart:developer';

import 'package:dialisaku/models/authenticaiton_models.dart';
import 'package:dialisaku/providers/authentication_provider.dart';
import 'package:dialisaku/providers/register_provider.dart';
// We reuse the authServiceProvider defined in the register_provider.dart file
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<LoginResponse?> build() {
    // The initial state is null, as no login attempt has been made yet.
    return null;
  }

  Future<void> login(String nik, String password) async {
    // Set state to loading
    state = const AsyncLoading();
    try {
      // Get the authentication service
      final authService = ref.read(authServiceProvider);

      // Perform the login request
      final loginResponse = await authService.fetchLogin(
        nik: nik,
        password: password,
      );

      // On success, update the central authentication provider with the user data and token
      ref.read(authProvider.notifier).setAuth(loginResponse);

      // Set the state to the result of the login attempt
      state = AsyncData(loginResponse);
    } catch (e, st) {
      log('login error: $e', stackTrace: st);
      // Set the state to an error
      state = AsyncError(e, st);
    }
  }
}

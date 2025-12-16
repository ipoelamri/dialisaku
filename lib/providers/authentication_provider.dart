import 'dart:convert';

import 'package:dialisaku/models/authenticaiton_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_provider.g.dart';

const _authStorageKey = 'authState';

/// This provider holds the authenticated user's data and token.
/// It will be null if no user is logged in.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<LoginResponse?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final authDataString = prefs.getString(_authStorageKey);

    if (authDataString == null) {
      return null;
    }

    try {
      final json = jsonDecode(authDataString) as Map<String, dynamic>;
      return LoginResponse.fromJson(json);
    } catch (e) {
      // If decoding fails, clear the invalid data
      await prefs.remove(_authStorageKey);
      return null;
    }
  }

  /// Sets the authentication data when login or registration is successful.
  Future<void> setAuth(LoginResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final authDataString = jsonEncode(response.toJson());
    await prefs.setString(_authStorageKey, authDataString);
    state = AsyncData(response);
  }

  /// Clears user data on logout.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authStorageKey);
    state = const AsyncData(null);
  }
}

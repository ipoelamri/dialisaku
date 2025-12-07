import 'package:dialisaku/models/authenticaiton_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

/// This provider holds the authenticated user's data and token.
/// It will be null if no user is logged in.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  LoginResponse? build() {
    // The initial state is null, meaning no user is logged in.
    return null;
  }

  /// Sets the authentication data when login or registration is successful.
  void setAuth(LoginResponse response) {
    state = response;
  }

  /// Clears user data on logout.
  void logout() {
    state = null;
  }
}
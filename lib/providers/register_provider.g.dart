// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authServiceHash() => r'0af7c894fe20c0940f680f113919ca2a058f58e6';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthenticationService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeProviderRef<AuthenticationService>;
String _$registerControllerHash() =>
    r'cf26fd7cbef78a04927543ae576164f4f79a3148';

/// See also [RegisterController].
@ProviderFor(RegisterController)
final registerControllerProvider = AutoDisposeAsyncNotifierProvider<
  RegisterController,
  RegisterResponse?
>.internal(
  RegisterController.new,
  name: r'registerControllerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$registerControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RegisterController = AutoDisposeAsyncNotifier<RegisterResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

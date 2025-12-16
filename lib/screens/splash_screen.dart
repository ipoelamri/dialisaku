import 'dart:async';
import 'dart:convert';

import 'package:dialisaku/models/authenticaiton_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<String?> _checkLoginFuture;

  @override
  void initState() {
    super.initState();
    _checkLoginFuture = _checkLoginStatus();
  }

  Future<String?> _checkLoginStatus() async {
    // Wait for a moment to show splash screen
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final authDataString = prefs.getString('authState');

    if (authDataString != null) {
      try {
        final loginResponse =
            LoginResponse.fromJson(jsonDecode(authDataString));
        if (loginResponse.data?.nik != null) {
          // If nik exists, user is logged in
          return '/home';
        }
      } catch (e) {
        // If decoding fails, force login
        return '/login';
      }
    }
    // If no auth data, force login
    return '/login';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: _checkLoginFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final route = snapshot.data;
            if (route != null) {
              // Use a post-frame callback to ensure the build is complete
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.go(route);
                }
              });
            }
            // Return an empty container while navigating
            return const SizedBox.shrink();
          }

          // Show Lottie animation while checking login status
          return Center(
            child: Lottie.asset(
              'lib/lottie/Medical App.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}

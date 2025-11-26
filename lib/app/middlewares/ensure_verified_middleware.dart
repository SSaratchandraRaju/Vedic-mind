import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class EnsureVerifiedMiddleware extends GetMiddleware {
  @override
  int? priority = 1; // high priority

  bool _requiresEmailVerification(User user) {
    // Block any account that has an email but is not verified, regardless of provider
    final hasEmail = (user.email != null && user.email!.isNotEmpty);
    return hasEmail && !(user.emailVerified);
  }

  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _requiresEmailVerification(user)) {
      return const RouteSettings(name: Routes.VERIFY_EMAIL);
    }
    return null;
  }
}

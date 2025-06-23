import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/app/modules/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated && route != '/login') {
      return const RouteSettings(name: '/login');
    }

    if (authController.isAuthenticated && route == '/login') {
      return const RouteSettings(name: '/dashboard');
    }

    return null;
  }
}

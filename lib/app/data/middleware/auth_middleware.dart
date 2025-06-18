import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Jika user belum login dan mencoba akses halaman yang butuh auth
    if (!authController.isAuthenticated && route != '/login') {
      return const RouteSettings(name: '/login');
    }

    // Jika user sudah login dan mencoba akses halaman login
    if (authController.isAuthenticated && route == '/login') {
      return const RouteSettings(name: '/dashboard');
    }

    return null;
  }
}
   
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/login_response.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/core/config.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString errorMessage = ''.obs;

  final GetStorage _storage = GetStorage();

  final String baseUrl = Config.url;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final token = _storage.read('token');
    final userData = _storage.read('user_data');

    if (token != null && userData != null) {
      currentUser.value = UserModel.fromJson(jsonDecode(userData));
      isLoggedIn.value = true;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

      if (response.statusCode == 200 && loginResponse.status == 'success') {
        await _saveUserData(
            loginResponse.data!.token, loginResponse.data!.user);

        currentUser.value = loginResponse.data?.user;
        isLoggedIn.value = true;

        Get.offAllNamed('/dashboard');
      } else {
        errorMessage.value = loginResponse.message;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserData(String token, UserModel user) async {
    await _storage.write('token', token);
    await _storage.write('user_data', jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await _storage.remove('token');
      await _storage.remove('user_data');

      currentUser.value = null;
      isLoggedIn.value = false;
      errorMessage.value = '';

      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat logout: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String? getToken() {
    return _storage.read('token');
  }

  bool get isAuthenticated => getToken() != null;

  UserModel? getCurrentUserData() {
    final userData = _storage.read('user_data');
    if (userData != null) {
      try {
        final userMap = userData is String ? jsonDecode(userData) : userData;
        return UserModel.fromJson(userMap);
      } catch (e) {
        print('Error parsing user_data: $e');
        return null;
      }
    }
    return null;
  }

  String? getUserName() {
    return getCurrentUserData()?.name;
  }

  String? getUserEmail() {
    return getCurrentUserData()?.email;
  }

  String? getUserDepartment() {
    return getCurrentUserData()?.departmentName;
  }

  String? getUserRole() {
    return getCurrentUserData()?.role;
  }

  String? getUserPhone() {
    return getCurrentUserData()?.phone;
  }
}

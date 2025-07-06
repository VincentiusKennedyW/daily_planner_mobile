// File: lib/app/services/base_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expense_tracker/core/config.dart';

class BaseService extends GetConnect {
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _configureHttpClient();
  }

  void _configureHttpClient() {
    // Set base URL untuk semua request
    httpClient.baseUrl = Config.url;

    // Set timeout untuk request
    httpClient.timeout = Duration(seconds: 30);

    // Request interceptor - dijalankan sebelum setiap request
    httpClient.addRequestModifier<void>((request) {
      // Tambahkan headers default
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      // Tambahkan token authorization jika ada
      final token = _storage.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      return request;
    });
  }

  // Helper method untuk handle response yang konsisten
  T? handleResponse<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) {
    if (response.hasError) {
      _handleHttpError(response);
      return null;
    }

    try {
      final data = response.body;
      if (data is Map<String, dynamic>) {
        return fromJson(data);
      }
      return null;
    } catch (e) {
      print('❌ Error parsing response: $e');
      Get.snackbar('Error', 'Failed to parse response');
      return null;
    }
  }

  // Handle HTTP errors secara konsisten
  void _handleHttpError(Response response) {
    switch (response.statusCode) {
      case 400:
        Get.snackbar('Bad Request', 'Invalid request data');
        break;
      case 401:
        Get.snackbar('Unauthorized', 'Please login again');
        break;
      case 403:
        Get.snackbar('Forbidden', 'Access denied');
        break;
      case 404:
        Get.snackbar('Not Found', 'Resource not found');
        break;
      case 500:
        Get.snackbar('Server Error', 'Internal server error');
        break;
      default:
        Get.snackbar('Error', 'HTTP Error: ${response.statusCode}');
    }
  }

  @override
  void onClose() {
    httpClient.close();
    super.onClose();
  }
}

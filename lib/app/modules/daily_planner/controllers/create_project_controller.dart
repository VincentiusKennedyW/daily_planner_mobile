import 'dart:convert';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/app/data/models/project_models/create_project_model.dart';
import 'package:expense_tracker/core/config.dart';

class CreateProjectController extends GetxController {
  final RxBool isLoadingCreate = false.obs;
  final RxString errorMessageCreate = ''.obs;
  
  final String baseUrl = Config.url;
  final GetStorage _storage = GetStorage();

  Future<bool> createProject(CreateProjectModel project) async {
    try {
      isLoadingCreate.value = true;
      errorMessageCreate.value = '';

      final url = '$baseUrl/project';
      final token = _storage.read('token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(project.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        errorMessageCreate.value = responseData['message'] ?? 'Gagal membuat project';
        return false;
      }
    } catch (e) {
      errorMessageCreate.value = 'Terjadi kesalahan: $e';
      developer.log('Error creating project: $e');
      return false;
    } finally {
      isLoadingCreate.value = false;
    }
  }
}

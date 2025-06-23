import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/responses/search_user_response.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/core/config.dart';

class SearchUserController extends GetxController {
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString keyword = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalUsers = 0.obs;
  final RxBool hasMore = false.obs;

  final GetStorage _storage = GetStorage();
  final String baseUrl = Config.url;
  Timer? _debounce;

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = _storage.read('token');
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  void debounceSearch(String keyword, {int delay = 500}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: delay), () {
      if (keyword.isNotEmpty) {
        searchUsers(keyword);
      } else {
        clearSearch();
      }
    });
  }

  Future<void> searchUsers(String searchKeyword,
      {int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      keyword.value = searchKeyword;

      if (page == 1) {
        users.clear();
        currentPage.value = 1;
      }

      final uri = Uri.parse('$baseUrl/users/search').replace(
        queryParameters: {
          'keyword': searchKeyword,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final searchResponse = SearchUserResponse.fromJson(responseData);

        if (searchResponse.status == 'success') {
          // Add new users to existing list (for pagination)
          users.addAll(searchResponse.data?.users ?? []);

          // Update pagination info
          currentPage.value = searchResponse.data?.pagination.page ?? 1;
          totalPages.value = searchResponse.data?.pagination.totalPages ?? 1;
          totalUsers.value = searchResponse.data?.pagination.total ?? 0;
          hasMore.value = currentPage.value < totalPages.value;
        } else {
          errorMessage.value = searchResponse.message;
        }
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Load more users (pagination)
  Future<void> loadMoreUsers() async {
    if (!hasMore.value || isLoading.value) return;

    await searchUsers(keyword.value, page: currentPage.value + 1);
  }

  // Refresh search
  Future<void> refreshSearch() async {
    if (keyword.value.isNotEmpty) {
      await searchUsers(keyword.value, page: 1);
    }
  }

  // Clear search results
  void clearSearch() {
    users.clear();
    keyword.value = '';
    errorMessage.value = '';
    currentPage.value = 1;
    totalPages.value = 1;
    totalUsers.value = 0;
    hasMore.value = false;
  }

  // Get user by ID from search results
  UserModel? getUserById(int id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Check if user exists in search results
  bool isUserInResults(int userId) {
    return users.any((user) => user.id == userId);
  }

  void _handleHttpError(http.Response response) {
    try {
      final responseData = json.decode(response.body);
      final message = responseData['message'] ?? 'Gagal mencari pengguna';

      switch (response.statusCode) {
        case 401:
          errorMessage.value = 'Sesi telah berakhir, silakan login kembali';
          // Handle logout if needed
          // Get.offAllNamed('/login');
          break;
        case 404:
          errorMessage.value = 'Pengguna tidak ditemukan';
          break;
        case 422:
          errorMessage.value = message;
          break;
        case 500:
          errorMessage.value = 'Server sedang bermasalah, coba lagi nanti';
          break;
        default:
          errorMessage.value = message;
      }
    } catch (e) {
      errorMessage.value = 'Gagal mencari pengguna';
    }
  }
}

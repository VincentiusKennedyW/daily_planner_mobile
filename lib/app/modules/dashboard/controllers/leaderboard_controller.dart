import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:expense_tracker/app/data/models/leaderboard_model.dart';
import 'package:expense_tracker/core/config.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderboardUser> leaderboard = <LeaderboardUser>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final String baseUrl = Config.url;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getLeaderboard();
  }

  Future<void> getLeaderboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final url = '$baseUrl/leaderboard';
      final token = _storage.read('token');

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final leaderboardResponse =
            LeaderboardResponse.fromJson(json.decode(response.body));

        if (leaderboardResponse.status == 'success') {
          leaderboard.value = leaderboardResponse.data.leaderboard;
        } else {
          errorMessage.value = leaderboardResponse.message;
        }
      } else {
        errorMessage.value = 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load leaderboard: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshLeaderboard() async {
    await getLeaderboard();
  }

  Future<void> loadMoreLeaderboard() async {
    // Implement pagination logic if needed
    // For now, we will just refresh the leaderboard
    await refreshLeaderboard();
  }

  Future<void> getMonthlyLeaderboard(DateTime monthFilter) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final lastDayOfMonth =
          DateTime(monthFilter.year, monthFilter.month + 1, 0, 23, 59, 59, 999);
      final formattedDate = lastDayOfMonth.toUtc().toIso8601String();
      final url = '$baseUrl/leaderboard?month=$formattedDate';
      final token = _storage.read('token');

      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final leaderboardResponse =
            LeaderboardResponse.fromJson(json.decode(response.body));

        if (leaderboardResponse.status == 'success') {
          leaderboard.value = leaderboardResponse.data.leaderboard;
        } else {
          errorMessage.value = leaderboardResponse.message;
        }
      } else {
        errorMessage.value = 'HTTP Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load monthly leaderboard: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

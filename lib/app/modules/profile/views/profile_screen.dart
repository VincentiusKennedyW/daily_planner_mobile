import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:expense_tracker/app/modules/dashboard/controllers/task_assignee_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetStorage _storage = GetStorage();
  final TaskAssigneeController _taskController =
      Get.find<TaskAssigneeController>();

  Map<String, dynamic> userDetails = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userData = _storage.read('user_data');

    if (userData != null) {
      try {
        final userMap = userData is String ? json.decode(userData) : userData;
        userDetails = {
          'name': userMap['name'] ?? 'User',
          'email': userMap['email'] ?? 'Email',
          'phone': userMap['phone'] ?? 'Phone',
          'nip': userMap['nip'] ?? 'NIP',
          'nik': userMap['nik'] ?? 'NIK',
          'department': userMap['department'] ?? 'Research and Development',
        };
      } catch (e) {
        developer.log(
          'Error parsing user_data: $e',
          name: 'ProfileScreen',
        );
      }
    }
  }

  // Calculate productivity percentage manually
  double calculateProductivity() {
    if (_taskController.totalTaskStatistics.value == null) {
      return 0.0;
    }

    final data = _taskController.totalTaskStatistics.value!.data;

    final totalTasks = data.total;
    final completedTasks = data.completed;

    // Avoid division by zero
    if (totalTasks == 0) return 0.0;

    return completedTasks / totalTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                    child: Text(
                      userDetails['name'] != null &&
                              userDetails['name'].isNotEmpty
                          ? userDetails['name'][0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Color(0xFF6366F1),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userDetails['name'] ?? 'User',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userDetails['department'] ??
                              'Research and Development',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userDetails['email'] ?? 'Email',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats Card
            Obx(() {
              final bool isDataLoading = _taskController.isLoading.value ||
                  _taskController.isLoadingMonthly.value;
              final totalStats =
                  _taskController.totalTaskStatistics.value?.data;
              final monthlyStats =
                  _taskController.monthlyTaskStatistics.value?.data;

              final completedTasks = totalStats?.completed.toString() ?? '0';
              final totalPoints = monthlyStats?.totalPoints.toString() ?? '0';
              final productivity =
                  '${(calculateProductivity() * 100).toStringAsFixed(1)}%';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: isDataLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Tugas Selesai', completedTasks),
                          _buildStatColumn('Total Poin', totalPoints),
                          _buildStatColumn('Produktivitas', productivity),
                        ],
                      ),
              );
            }),

            const SizedBox(height: 20),

            // Personal Information Section
            _buildSettingsSection(
              'Informasi Pribadi',
              [
                _buildInfoItem('NIP', userDetails['nip'] ?? 'Tidak ada'),
                _buildInfoItem('NIK', userDetails['nik'] ?? 'Tidak ada'),
                _buildInfoItem('Phone', userDetails['phone'] ?? 'Tidak ada'),
              ],
            ),

            // Settings Menu
            _buildSettingsSection(
              'Akun Saya',
              [
                _buildSettingsItem(Icons.person_outline, 'Informasi Pribadi'),
                _buildSettingsItem(Icons.wallet_outlined, 'Pembayaran'),
                _buildSettingsItem(Icons.location_on_outlined, 'Alamat'),
              ],
            ),

            _buildSettingsSection(
              'Preferensi',
              [
                _buildSettingsItem(Icons.notifications_outlined, 'Notifikasi'),
                _buildSettingsItem(Icons.language_outlined, 'Bahasa'),
                _buildSettingsItem(Icons.dark_mode_outlined, 'Tema Aplikasi'),
              ],
            ),

            _buildSettingsSection(
              'Lainnya',
              [
                _buildSettingsItem(Icons.help_outline, 'Bantuan'),
                _buildSettingsItem(Icons.info_outline, 'Tentang Aplikasi'),
                _buildSettingsItem(Icons.exit_to_app, 'Keluar', isLogout: true),
              ],
            ),

            const SizedBox(height: 40),
            Text('Versi Aplikasi 1.0.0',
                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6366F1),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title,
      {bool isLogout = false}) {
    return InkWell(
      onTap: () {
        if (isLogout) {
          // Handle logout
          _storage.remove('token');
          _storage.remove('user_data');
          Get.offAllNamed('/login');
        } else {
          // Navigate to respective settings
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Membuka $title')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : const Color(0xFF6366F1),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isLogout ? Colors.red : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

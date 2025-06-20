import 'package:expense_tracker/app/data/models/task_models/create_task_model.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/task_controller.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/search_user_controller.dart';
import 'package:expense_tracker/core/task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvancedAddTaskSheet extends StatefulWidget {
  const AdvancedAddTaskSheet({super.key});

  @override
  _AdvancedAddTaskSheetState createState() => _AdvancedAddTaskSheetState();
}

class _AdvancedAddTaskSheetState extends State<AdvancedAddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.development;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _dueDate;
  TimeOfDay _dueTime = TimeOfDay(hour: 23, minute: 59);
  final int _estimatedHours = 1;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  final TaskController taskController = Get.find<TaskController>();
  final SearchUserController searchController = Get.put(SearchUserController());
  final TextEditingController _searchTextController = TextEditingController();
  final List<UserModel> _selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Text(
                  'Buat Planning Baru',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Judul Task'),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan judul task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle('Deskripsi'),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Deskripsi detail task...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.description_rounded),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSectionTitle('Kategori'),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: TaskCategory.values.length,
                      itemBuilder: (context, index) {
                        final category = TaskCategory.values[index];
                        final isSelected = category == _selectedCategory;

                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? category.color.withOpacity(0.1)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? category.color
                                    : Colors.grey.withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category.icon,
                                  color: isSelected
                                      ? category.color
                                      : Colors.grey[600],
                                  size: 28,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? category.color
                                        : Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${category.points} poin',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: isSelected
                                        ? category.color
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),

                  // IMPROVED PRIORITY SECTION
                  _buildSectionTitle('Prioritas'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TaskPriority.values.map((priority) {
                      final isSelected = priority == _selectedPriority;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedPriority = priority),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? priority.color.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? priority.color
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: priority.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                priority.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? priority.color
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  _buildSectionTitle('Assign ke'),

// Search Field dengan debouncing dan better UX
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchTextController,
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau email pengguna...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF6366F1)),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Loading indicator di dalam search field
                            Obx(() => searchController.isLoading.value
                                ? Container(
                                    margin: EdgeInsets.only(right: 8),
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFF6366F1)),
                                    ),
                                  )
                                : SizedBox.shrink()),
                            // Clear button
                            if (_searchTextController.text.isNotEmpty)
                              IconButton(
                                icon:
                                    Icon(Icons.clear, color: Colors.grey[600]),
                                onPressed: () {
                                  _searchTextController.clear();
                                  searchController.clearSearch();
                                },
                              ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFF6366F1), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onChanged: (value) {
                        // Debounce search untuk mengurangi API calls
                        searchController.debounceSearch(value);
                      },
                    ),
                  ),

                  SizedBox(height: 16),

// Selected Users Display - Tampil sebelum hasil pencarian
                  if (_selectedUsers.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF6366F1).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Color(0xFF6366F1).withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people,
                                  color: Color(0xFF6366F1), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Pengguna Terpilih (${_selectedUsers.length}):',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6366F1),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // Spacer(),
                              // if (_selectedUsers.length > 1)
                              //   TextButton(
                              //     onPressed: () {
                              //       setState(() => _selectedUsers.clear());
                              //     },
                              //     child: Text(
                              //       'Hapus Semua',
                              //       style: TextStyle(
                              //         color: Colors.red[600],
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedUsers.map((user) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Color(0xFF6366F1).withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor:
                                          Color(0xFF6366F1).withOpacity(0.1),
                                      child: Text(
                                        user.name!.isNotEmpty
                                            ? user.name![0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: Color(0xFF6366F1),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints(maxWidth: 120),
                                      child: Text(
                                        user.name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.grey[800],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedUsers.removeWhere(
                                              (u) => u.id == user.id);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],

// // Search Results
                  Obx(() {
                    // Jika sedang loading dan ada text pencarian
                    if (searchController.isLoading.value &&
                        _searchTextController.text.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF6366F1)),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Mencari pengguna...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Jika tidak ada hasil dan ada text pencarian
                    if (searchController.users.isEmpty &&
                        _searchTextController.text.isNotEmpty &&
                        !searchController.isLoading.value) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 6, bottom: 12, left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        margin: EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            Icon(Icons.person_search,
                                size: 48, color: Colors.grey[400]),
                            SizedBox(height: 8),
                            Text(
                              'Pengguna tidak ditemukan',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Coba gunakan kata kunci lain',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Jika ada hasil pencarian
                    if (searchController.users.isNotEmpty ||
                        _selectedUsers.isNotEmpty) {
                      return Container(
                        constraints: BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: searchController.users.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            final user = searchController.users[index];
                            final isSelected =
                                _selectedUsers.any((u) => u.id == user.id);

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    // Remove user dari selected list
                                    _selectedUsers
                                        .removeWhere((u) => u.id == user.id);
                                  } else {
                                    // Add user ke selected list
                                    _selectedUsers.add(user);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF6366F1).withOpacity(0.08)
                                      : Colors.transparent,
                                  borderRadius: index == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        )
                                      : index ==
                                              searchController.users.length - 1
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            )
                                          : BorderRadius.zero,
                                ),
                                child: Row(
                                  children: [
                                    // Checkbox untuk multiple selection
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0xFF6366F1)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? Color(0xFF6366F1)
                                              : Colors.grey.withOpacity(0.5),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12),
                                    // Avatar
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Color(0xFF6366F1).withOpacity(0.1),
                                      child: Text(
                                        user.name!.isNotEmpty
                                            ? user.name![0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: Color(0xFF6366F1),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // User info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          if (user.email!.isNotEmpty) ...[
                                            SizedBox(height: 2),
                                            Text(
                                              user.email!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Selected indicator
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF6366F1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Dipilih',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (_selectedUsers.isNotEmpty) {
                      return Container(
                        constraints: BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: searchController.users.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            final user = searchController.users[index];
                            final isSelected =
                                _selectedUsers.any((u) => u.id == user.id);

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    // Remove user dari selected list
                                    _selectedUsers
                                        .removeWhere((u) => u.id == user.id);
                                  } else {
                                    // Add user ke selected list
                                    _selectedUsers.add(user);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF6366F1).withOpacity(0.08)
                                      : Colors.transparent,
                                  borderRadius: index == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        )
                                      : index ==
                                              searchController.users.length - 1
                                          ? BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            )
                                          : BorderRadius.zero,
                                ),
                                child: Row(
                                  children: [
                                    // Checkbox untuk multiple selection
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Color(0xFF6366F1)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? Color(0xFF6366F1)
                                              : Colors.grey.withOpacity(0.5),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12),
                                    // Avatar
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Color(0xFF6366F1).withOpacity(0.1),
                                      child: Text(
                                        user.name!.isNotEmpty
                                            ? user.name![0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: Color(0xFF6366F1),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // User info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          if (user.email!.isNotEmpty) ...[
                                            SizedBox(height: 2),
                                            Text(
                                              user.email!,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Selected indicator
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF6366F1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Dipilih',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

// Error message dengan better styling
                  Obx(() => searchController.errorMessage.value.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red[700], size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  searchController.errorMessage.value,
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink()),

                  _buildSectionTitle('Deadline'),
                  Row(
                    children: [
                      Expanded(
                        // flex: 2,
                        child: InkWell(
                          onTap: _selectDueDate,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12),
                              color: _dueDate != null
                                  ? Color(0xFF6366F1).withOpacity(0.05)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: _dueDate != null
                                      ? Color(0xFF6366F1)
                                      : Colors.grey[600],
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tanggal',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        _dueDate != null
                                            ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                                            : 'Pilih tanggal',
                                        style: TextStyle(
                                          color: _dueDate != null
                                              ? Colors.black87
                                              : Colors.grey[600],
                                          fontWeight: _dueDate != null
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(width: 12),
                      // Expanded(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border:
                      //           Border.all(color: Colors.grey.withOpacity(0.3)),
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Column(
                      //       children: [
                      //         Container(
                      //           padding: EdgeInsets.symmetric(
                      //               vertical: 8, horizontal: 12),
                      //           child: Text(
                      //             'Estimasi',
                      //             style: TextStyle(
                      //               fontSize: 10,
                      //               color: Colors.grey[600],
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //         ),
                      //         Row(
                      //           children: [
                      //             Expanded(
                      //               child: InkWell(
                      //                 onTap: () => setState(() =>
                      //                     _estimatedHours =
                      //                         math.max(1, _estimatedHours - 1)),
                      //                 child: Container(
                      //                   padding:
                      //                       EdgeInsets.symmetric(vertical: 8),
                      //                   child: Icon(Icons.remove,
                      //                       color: Color(0xFF6366F1), size: 16),
                      //                 ),
                      //               ),
                      //             ),
                      //             Container(
                      //               padding: EdgeInsets.symmetric(vertical: 8),
                      //               child: Text(
                      //                 '$_estimatedHours jam',
                      //                 style: TextStyle(
                      //                   fontSize: 12,
                      //                   fontWeight: FontWeight.w600,
                      //                   color: Color(0xFF6366F1),
                      //                 ),
                      //               ),
                      //             ),
                      //             Expanded(
                      //               child: InkWell(
                      //                 onTap: () =>
                      //                     setState(() => _estimatedHours++),
                      //                 child: Container(
                      //                   padding:
                      //                       EdgeInsets.symmetric(vertical: 8),
                      //                   child: Icon(Icons.add,
                      //                       color: Color(0xFF6366F1), size: 16),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16),

                  _buildSectionTitle('Tags'),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          decoration: InputDecoration(
                            hintText: 'Tambah tag...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.tag_rounded),
                          ),
                          onSubmitted: _addTag,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _addTag(_tagController.text),
                        icon: Icon(Icons.add_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Color(0xFF6366F1).withOpacity(0.1),
                          foregroundColor: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                  if (_tags.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tag,
                                style: TextStyle(
                                  color: Color(0xFF6366F1),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => setState(() => _tags.remove(tag)),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(result: false);
                      _searchTextController.clear();
                      _selectedUsers.clear();
                      searchController.users.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Batal'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Obx(() => ElevatedButton(
                        onPressed: taskController.isLoadingCreate.value
                            ? null
                            : () async {
                                if (_titleController.text.trim().isEmpty) {
                                  Get.snackbar(
                                      'Error', 'Judul task harus diisi');
                                  return;
                                }

                                DateTime? finalDueDate;
                                if (_dueDate != null) {
                                  finalDueDate = DateTime(
                                    _dueDate!.year,
                                    _dueDate!.month,
                                    _dueDate!.day,
                                    _dueTime.hour,
                                    _dueTime.minute,
                                  );
                                }

                                final assignees = _selectedUsers
                                    .map((user) => user.id)
                                    .whereType<int>()
                                    .toList();

                                final newTask = CreateTaskModel(
                                  title: _titleController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  category: _selectedCategory,
                                  priority: _selectedPriority,
                                  status: TaskStatus.todo,
                                  assignees: assignees,
                                  dueDate: finalDueDate,
                                  tags: _tags,
                                  estimatedHours: _estimatedHours,
                                  point: _selectedCategory.points,
                                );

                                final success =
                                    await taskController.createTask(newTask);

                                if (success) {
                                  Get.back(result: true);
                                  _searchTextController.clear();
                                  _selectedUsers.clear();
                                  searchController.users.clear();
                                  Get.snackbar(
                                    'Sukses',
                                    'Task berhasil dibuat',
                                    backgroundColor:
                                        Colors.green.withOpacity(0.1),
                                    colorText: Colors.green[800],
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    taskController.errorMessageCreate.value,
                                    backgroundColor:
                                        Colors.red.withOpacity(0.1),
                                    colorText: Colors.red[800],
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: taskController.isLoadingCreate.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Membuat...'),
                                ],
                              )
                            : Text('Buat Planning'),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  void _selectDueTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _dueTime = time);
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }
}

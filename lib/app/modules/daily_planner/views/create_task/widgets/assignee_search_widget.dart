import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/app/data/models/user_model.dart';
import 'package:expense_tracker/app/modules/daily_planner/controllers/search_user_controller.dart';

class AssigneeSearchWidget extends StatefulWidget {
  final List<UserModel> selectedUsers;
  final Function(List<UserModel>) onUsersChanged;

  const AssigneeSearchWidget({
    super.key,
    required this.selectedUsers,
    required this.onUsersChanged,
  });

  @override
  State<AssigneeSearchWidget> createState() => AssigneeSearchWidgetState();
}

class AssigneeSearchWidgetState extends State<AssigneeSearchWidget> {
  final _searchTextController = TextEditingController();
  final SearchUserController searchController = Get.put(SearchUserController());
  late List<UserModel> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _selectedUsers = List.from(widget.selectedUsers);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  void _updateSelectedUsers() {
    widget.onUsersChanged(_selectedUsers);
  }

  void _toggleUserSelection(UserModel user) {
    setState(() {
      final isSelected = _selectedUsers.any((u) => u.id == user.id);
      if (isSelected) {
        _selectedUsers.removeWhere((u) => u.id == user.id);
      } else {
        _selectedUsers.add(user);
      }
    });
    _updateSelectedUsers();
  }

  void _removeUser(UserModel user) {
    setState(() {
      _selectedUsers.removeWhere((u) => u.id == user.id);
    });
    _updateSelectedUsers();
  }

  void _clearSearch() {
    _searchTextController.clear();
    searchController.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchField(),
        const SizedBox(height: 16),
        if (_selectedUsers.isNotEmpty) ...[
          _buildSelectedUsersSection(),
          const SizedBox(height: 16),
        ],
        _buildSearchResults(),
        _buildErrorMessage(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchTextController,
        decoration: InputDecoration(
          hintText: 'Cari nama atau email pengguna...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => searchController.isLoading.value
                  ? Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 16,
                      height: 16,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      ),
                    )
                  : const SizedBox.shrink()),
              if (_searchTextController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: _clearSearch,
                ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: (value) {
          searchController.debounceSearch(value);
        },
      ),
    );
  }

  Widget _buildSelectedUsersSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              Text(
                'Pengguna Terpilih (${_selectedUsers.length}):',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedUsers
                .map((user) => _buildSelectedUserChip(user))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUserChip(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
            child: Text(
              user.name!.isNotEmpty ? user.name![0].toUpperCase() : 'U',
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
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
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _removeUser(user),
            child: Container(
              padding: const EdgeInsets.all(2),
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
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (searchController.isLoading.value &&
          _searchTextController.text.isNotEmpty) {
        return _buildLoadingState();
      }

      if (searchController.users.isEmpty &&
          _searchTextController.text.isNotEmpty &&
          !searchController.isLoading.value) {
        return _buildNoResultsState();
      }

      if (searchController.users.isNotEmpty) {
        return _buildResultsList();
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
          SizedBox(height: 12),
          Text(
            'Mencari pengguna...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 6, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Icon(Icons.person_search, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
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

  Widget _buildResultsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: searchController.users.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final user = searchController.users[index];
          final isSelected = _selectedUsers.any((u) => u.id == user.id);

          return _buildUserListItem(user, isSelected, index);
        },
      ),
    );
  }

  Widget _buildUserListItem(UserModel user, bool isSelected, int index) {
    return InkWell(
      onTap: () => _toggleUserSelection(user),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.08)
              : Colors.transparent,
          borderRadius: _getItemBorderRadius(index),
        ),
        child: Row(
          children: [
            _buildCheckbox(isSelected),
            const SizedBox(width: 12),
            _buildUserAvatar(user),
            const SizedBox(width: 12),
            _buildUserInfo(user),
            if (isSelected) _buildSelectedIndicator(),
          ],
        ),
      ),
    );
  }

  BorderRadius _getItemBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (index == searchController.users.length - 1) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }
    return BorderRadius.zero;
  }

  Widget _buildCheckbox(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? const Color(0xFF6366F1)
              : Colors.grey.withOpacity(0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            )
          : null,
    );
  }

  Widget _buildUserAvatar(UserModel user) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
      child: Text(
        user.name!.isNotEmpty ? user.name![0].toUpperCase() : 'U',
        style: const TextStyle(
          color: Color(0xFF6366F1),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 2),
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
    );
  }

  Widget _buildSelectedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Dipilih',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Obx(() => searchController.errorMessage.value.isNotEmpty
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    searchController.errorMessage.value,
                    style: TextStyle(color: Colors.red[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink());
  }
}

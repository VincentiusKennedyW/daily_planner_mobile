import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailHeader extends StatelessWidget implements PreferredSizeWidget {
  const TaskDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.grey[800]),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Detail Task',
        style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert_rounded, color: Colors.grey[800]),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
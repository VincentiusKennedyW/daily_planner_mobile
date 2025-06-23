import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required bool isSuccess,
  required String title,
  required String message,
}) {
  Get.snackbar(
    '',
    '',
    titleText: Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isSuccess ? Colors.green : Colors.red).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle : Icons.error_outline,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 24,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSuccess ? Colors.green[700] : Colors.red[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    messageText: const SizedBox.shrink(),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    borderRadius: 20,
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(20),
    duration: Duration(seconds: 3),
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    // forwardAnimationCurve: Curves.elasticOut,
    // reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(milliseconds: 1000),
    boxShadows: [
      BoxShadow(
        color: (isSuccess ? Colors.green : Colors.red).withOpacity(0.1),
        blurRadius: 25,
        offset: const Offset(0, 10),
        spreadRadius: 2,
      ),
    ],
    borderColor: (isSuccess ? Colors.green : Colors.red).withOpacity(0.2),
    borderWidth: 1.5,
  );
}

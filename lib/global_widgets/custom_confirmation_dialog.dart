import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Custom Confirmation Dialog Widget
class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData? icon;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Ya',
    this.cancelText = 'Batal',
    this.icon,
    this.iconColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header dengan icon
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDangerous ? Colors.red.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color:
                          iconColor ?? (isDangerous ? Colors.red : Colors.blue),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon ??
                          (isDangerous
                              ? Icons.warning_rounded
                              : Icons.help_outline_rounded),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: Container(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.back(result: false);
                              if (onCancel != null) onCancel!();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color:
                                    cancelButtonColor ?? Colors.grey.shade300,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              cancelText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: cancelButtonColor ?? Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),

                      // Confirm Button
                      Expanded(
                        child: Container(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back(result: true);
                              if (onConfirm != null) onConfirm!();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: confirmButtonColor ??
                                  (isDangerous ? Colors.red : Colors.blue),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              confirmText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Global Helper Function untuk menampilkan confirmation dialog
class ConfirmationDialogHelper {
  // Standard confirmation dialog
  static Future<bool?> show({
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    IconData? icon,
    Color? iconColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) async {
    return await Get.dialog<bool>(
      CustomConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        iconColor: iconColor,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDangerous: isDangerous,
      ),
      barrierDismissible: false,
    );
  }

  // Delete confirmation dialog
  static Future<bool?> showDelete({
    required String title,
    required String message,
    String confirmText = 'Hapus',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return await show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.delete_outline_rounded,
      iconColor: Colors.red,
      confirmButtonColor: Colors.red,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: true,
    );
  }

  // Logout confirmation dialog
  static Future<bool?> showLogout({
    String title = 'Keluar Aplikasi',
    String message = 'Apakah Anda yakin ingin keluar dari aplikasi?',
    String confirmText = 'Keluar',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return await show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.logout_rounded,
      iconColor: Colors.orange,
      confirmButtonColor: Colors.orange,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: true,
    );
  }

  // Success confirmation dialog
  static Future<bool?> showSuccess({
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Tutup',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return await show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.green,
      confirmButtonColor: Colors.green,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  // Warning confirmation dialog
  static Future<bool?> showWarning({
    required String title,
    required String message,
    String confirmText = 'Lanjutkan',
    String cancelText = 'Batal',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return await show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.amber,
      confirmButtonColor: Colors.amber,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: true,
    );
  }

  // Info confirmation dialog
  static Future<bool?> showInfo({
    required String title,
    required String message,
    String confirmText = 'Mengerti',
    String cancelText = 'Tutup',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return await show(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: Icons.info_outline_rounded,
      iconColor: Colors.blue,
      confirmButtonColor: Colors.blue,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }
}

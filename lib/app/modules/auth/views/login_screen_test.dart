// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';

// class LoginView extends GetView<AuthController> {
//   const LoginView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: controller.loginFormKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Logo atau Header
//                     const Icon(
//                       Icons.lock_outline,
//                       size: 80,
//                       color: Colors.blue,
//                     ),
//                     const SizedBox(height: 32),

//                     // Title
//                     const Text(
//                       'Login',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 8),

//                     const Text(
//                       'Silakan masuk ke akun Anda',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 32),

//                     // Email Field
//                     TextFormField(
//                       controller: controller.emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         hintText: 'Masukkan email Anda',
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.blue),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Email tidak boleh kosong';
//                         }
//                         if (!GetUtils.isEmail(value)) {
//                           return 'Format email tidak valid';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Password Field
//                     Obx(() {
//                       print('Error Text: ${controller.errorMessage.value}');
//                       return TextFormField(
//                         controller: controller.passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           hintText: 'Masukkan password Anda',
//                           prefixIcon: const Icon(Icons.lock_outlined),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: Colors.blue),
//                           ),
//                           errorText: controller.errorMessage.value.isEmpty
//                               ? null
//                               : controller.errorMessage.value,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Password tidak boleh kosong';
//                           }
//                           if (value.length < 6) {
//                             return 'Password minimal 6 karakter';
//                           }
//                           return null;
//                         },
//                       );
//                     }),

//                     const SizedBox(height: 24),

//                     // Login Button
//                     Obx(() => ElevatedButton(
//                           onPressed: controller.isLoading.value
//                               ? null
//                               : controller.login,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 2,
//                           ),
//                           child: controller.isLoading.value
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : const Text(
//                                   'Login',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                         )),
//                     const SizedBox(height: 16),

//                     // Forgot Password (Optional)
//                     TextButton(
//                       onPressed: () {
//                         // Navigate to forgot password
//                         Get.toNamed('/forgot-password');
//                       },
//                       child: const Text(
//                         'Lupa Password?',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

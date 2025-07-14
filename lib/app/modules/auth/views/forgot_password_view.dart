import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/custom_form_field.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final emailController = TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFe0f7fa), Color(0xFFb2dfdb)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.spa, color: Color(0xFF43a047), size: 36.r),
                ),
                24.verticalSpace,
                Container(
                  width: 350.w,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Reset Password',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        'Get back into your account',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      32.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Reset Your Password', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      8.verticalSpace,
                      Text(
                        "Enter your email address and we'll send you instructions to reset your password.",
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                      20.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Email Address', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      8.verticalSpace,
                      CustomFormField(
                        controller: emailController,
                        hint: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email_outlined, color: theme.primaryColor),
                        backgroundColor: Colors.grey[100],
                        borderRound: 12.r,
                      ),
                      24.verticalSpace,
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.forgotPassword(emailController.text),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            backgroundColor: Color(0xFF43a047),
                            foregroundColor: Colors.white,
                            textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ).copyWith(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                              return states.contains(MaterialState.disabled)
                                  ? Colors.green.withOpacity(0.5)
                                  : Color(0xFF43a047);
                            }),
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text('Send Reset Instructions'),
                        ),
                      )),
                      16.verticalSpace,
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          '←  Back to Sign In',
                          style: TextStyle(
                            color: Color(0xFF43a047),
                            fontWeight: FontWeight.bold,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
                Text(
                  '© 2025 Antika Farms. Growing together with technology.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
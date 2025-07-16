import 'package:antika_farm/app/components/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/custom_form_field.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final agreeTerms = false.obs;
    final RxBool obscurePassword = true.obs;
    final RxBool obscureConfirmPassword = true.obs;

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
                  width: 370.w,
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
                        'Join Antika Farms',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        'Create your account to get started',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      32.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Full Name', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      8.verticalSpace,
                      CustomFormField(
                        controller: nameController,
                        hint: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        prefixIcon: Icon(Icons.person_outline, color: theme.primaryColor),
                        backgroundColor: Colors.grey[100],
                        borderRound: 12.r,
                      ),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Email Address', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      8.verticalSpace,
                      CustomFormField(
                        controller: emailController,
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email_outlined, color: theme.primaryColor),
                        backgroundColor: Colors.grey[100],
                        borderRound: 12.r,
                      ),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Phone Number', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      8.verticalSpace,
                      CustomFormField(
                        controller: phoneController,
                        hint: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icon(Icons.phone_outlined, color: theme.primaryColor),
                        backgroundColor: Colors.grey[100],
                        borderRound: 12.r,
                      ),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Password', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      8.verticalSpace,
                      Obx(() => CustomFormField(
                        controller: passwordController,
                        hint: 'Create a password',
                        obscureText: obscurePassword.value,
                        prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor),
                        backgroundColor: Colors.grey[100],
                        borderRound: 12.r,
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword.value ? Icons.visibility_off : Icons.visibility, color: theme.primaryColor),
                          onPressed: () => obscurePassword.value = !obscurePassword.value,
                        ),
                      )),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Confirm Password', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      8.verticalSpace,
                      Obx(() => CustomFormField(
                        controller: confirmPasswordController,
                        hint: 'Confirm your password',
                        obscureText: obscureConfirmPassword.value,
                        prefixIcon: Icon(Icons.lock_outline, color: theme.primaryColor),
                        backgroundColor: Colors.grey[100],
                        borderRound: 12.r,
                        suffixIcon: IconButton(
                          icon: Icon(obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility, color: theme.primaryColor),
                          onPressed: () => obscureConfirmPassword.value = !obscureConfirmPassword.value,
                        ),
                      )),
                      16.verticalSpace,
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: agreeTerms.value,
                                onChanged: (val) => agreeTerms.value = val ?? false,
                                activeColor: Color(0xFF43a047),
                              )),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.black87),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: const TextStyle(color: Color(0xFF43a047), decoration: TextDecoration.underline),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(color: Color(0xFF43a047), decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value || !agreeTerms.value
                              ? null
                              : () {
                                  if (passwordController.text != confirmPasswordController.text) {
                                    CustomSnackBar.showCustomErrorSnackBar(title: 'Error', message: 'Passwords do not match');
                                    return;
                                  }
                                  controller.register(nameController.text, emailController.text, passwordController.text);
                                },
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
                              : Text('Create Account'),
                        ),
                      )),
                      16.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ', style: theme.textTheme.bodyMedium),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              'Sign in here',
                              style: TextStyle(
                                color: Color(0xFF43a047),
                                fontWeight: FontWeight.bold,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
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
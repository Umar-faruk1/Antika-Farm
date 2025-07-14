import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setLoggedIn(bool value) {
    isLoggedIn.value = value;
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      setLoggedIn(true);
      Get.offAllNamed('/base');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      setLoading(false);
    }
  }

  Future<void> register(String name, String email, String password) async {
    setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      setLoggedIn(true);
      Get.offAllNamed('/base');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed');
    } finally {
      setLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar('Success', 'Password reset email sent');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset email');
    } finally {
      setLoading(false);
    }
  }

  void logout() {
    setLoggedIn(false);
    Get.offAllNamed('/welcome');
  }
} 
import 'package:antika_farm/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../components/custom_snackbar.dart';


class AuthController extends GetxController {
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? currentUser;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setLoggedIn(bool value) {
    isLoggedIn.value = value;
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
      if (!userDoc.exists) {
        CustomSnackBar.showCustomErrorSnackBar(title: 'Error', message: 'User data not found');
        return;
      }
      currentUser = UserModel.fromMap(userDoc.data()!);
      if (currentUser == null || currentUser!.status != 'active') {
        CustomSnackBar.showCustomErrorSnackBar(title: 'Error', message: 'Account is not active');
        return;
      }
      setLoggedIn(true);
      CustomSnackBar.showCustomSnackBar(title: 'Success', message: 'Login successful');
      if (currentUser != null && currentUser!.role == 'admin') {
        Get.offAllNamed('/admin');
      } else {
        Get.offAllNamed('/base');
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(title: 'Error', message: 'Invalid email or password');
    } finally {
      setLoading(false);
    }
  }

  Future<void> register(String name, String email, String password) async {
    setLoading(true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Check if this is the first user (admin)
      final usersSnapshot = await _firestore.collection('users').get();
      String role = usersSnapshot.docs.isEmpty ? 'admin' : 'user';
      final userModel = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        role: role,
        status: 'active',
      );
      await _firestore.collection('users').doc(credential.user!.uid).set(userModel.toMap());
      currentUser = userModel;
      setLoggedIn(true);
      if (currentUser != null && currentUser!.role == 'admin') {
        Get.offAllNamed('/admin');
      } else {
        Get.offAllNamed('/base');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> forgotPassword(String email) async {
    setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setLoading(false);
    }
  }

  void logout() async {
    await _auth.signOut();
    setLoggedIn(false);
    currentUser = null;
    Get.offAllNamed('/login');
  }
} 
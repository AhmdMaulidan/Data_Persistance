import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('logged_in') ?? false;
    if (isLoggedIn.value) {
      Get.offAllNamed('/home');
    }
  }

  Future<void> login(String email, String password) async {
    // Contoh login sederhana
    if (email == "admin" && password == "123") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      isLoggedIn.value = true;
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Error', 'Email atau password salah');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}

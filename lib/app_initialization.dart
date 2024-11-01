import 'package:shared_preferences/shared_preferences.dart';

class AppInitialization {
  static Future<String> determineInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    // Kiểm tra xem đã có token hay chưa
    if (token != null) {
      // Nếu có token, điều hướng đến MainTabView
      return '/main';
    } else {
      // Nếu không có token, điều hướng đến OnBoardingView
      return '/onboarding';
    }
  }
}

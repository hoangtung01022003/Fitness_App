// app_router.dart
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:fitness/view/main_tab/main_tab_view.dart';
import 'package:fitness/view/on_boarding/on_boarding_view.dart';
import 'package:fitness/view/profile/edit_profile.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainTabView());
      case '/edit_profile':
        return MaterialPageRoute(
          builder: (_) => const EditProfile(),
        );
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      default:
        return MaterialPageRoute(
            builder: (_) => const MainTabView()); // Route mặc định
    }
  }
}

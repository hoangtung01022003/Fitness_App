import 'package:fitness/router.dart';
import 'package:flutter/material.dart';
import 'common/colo_extension.dart';
import 'app_initialization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo đã khởi tạo Flutter
  String initialRoute = await AppInitialization.determineInitialRoute(); // Kiểm tra và lấy route khởi đầu

  runApp(MyApp(initialRoute: initialRoute)); // Truyền route vào MyApp
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute}); // Nhận initialRoute

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins"
      ),
      initialRoute: initialRoute, // Sử dụng initialRoute đã kiểm tra
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

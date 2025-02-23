import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'app_initialization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo đã khởi tạo Flutter

  // Load .env file
  await dotenv.load(fileName: ".env");

  String initialRoute = await AppInitialization.determineInitialRoute(); // Kiểm tra và lấy route khởi đầu

  // Lấy API key từ .env
  String? apiKey = dotenv.env['GEMINI_API_KEY'];

  // Khởi tạo Gemini với API key
  Gemini.init(apiKey: apiKey ?? '');

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
      theme: ThemeData(primaryColor: TColor.primaryColor1, fontFamily: "Poppins"),
      initialRoute: initialRoute, // Sử dụng initialRoute đã kiểm tra
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
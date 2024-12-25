import 'package:fitness/providers/chat_provider.dart';
import 'package:fitness/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'common/colo_extension.dart';
import 'app_initialization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo đã khởi tạo Flutter
  String initialRoute = await AppInitialization
      .determineInitialRoute(); // Kiểm tra và lấy route khởi đầu
  Gemini.init(apiKey: 'AIzaSyC_eYGI-Nn-SdUolYbqE2NzTupOTPjym88');
  await ChatProvider.initHive();
  runApp(
    MyApp(initialRoute: initialRoute),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute}); // Nhận initialRoute

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: TColor.primaryColor1, fontFamily: "Poppins"),
      initialRoute: initialRoute, // Sử dụng initialRoute đã kiểm tra
      // initialRoute:  const MyHomePage(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

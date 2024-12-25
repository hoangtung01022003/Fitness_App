import 'package:fitness/api/auth_controllers.dart';
import 'package:fitness/api/api_service.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common/assets.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/loading_helper.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/view/login/signup_view.dart';
import 'package:fitness/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isCheck = false;
  bool _isObscured =
      true; // Biến trạng thái để theo dõi trạng thái hiển thị mật khẩu

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured; // Chuyển đổi trạng thái
    });
  }

  final ApiService _authService = ApiService();
  final AuthControllers _authControllers = AuthControllers();

  @override
  void dispose() {
    _authControllers.emailController.dispose(); // Gọi dispose của controller
    _authControllers.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.09,
                ),
                // SizedBox(
                //   height: media.width * 0.04,
                // ),
                RoundTextFormField(
                  controller: _authControllers.emailController,
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  // keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextFormField(
                  controller: _authControllers.passwordController,
                  hitText: "Password",
                  icon: TImages.lock,
                  obscureText: _isObscured,
                  rigtIcon: TextButton(
                      onPressed: _togglePasswordVisibility,
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
                        child: Icon(
                          _isObscured
                              ? Icons
                                  .visibility_off // Hình ảnh cho "Show" (khi mật khẩu bị ẩn)
                              : Icons
                                  .visibility, // Hình ảnh cho "Hide" (khi mật khẩu được hiển thị)
                          color: Colors.grey,
                        ),
                      )),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                          color: TColor.gray,
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                const Spacer(),
                RoundButton(
                  title: "Login",
                  onPressed: () async {
                    // Hiển thị loading
                    LoadingHelper.showLoadingOverlay(context);

                    try {
                      // Gọi hàm đăng nhập từ ApiService với email và password từ controller
                      final response = await _authService.loginUser(
                        _authControllers.emailController.text,
                        _authControllers.passwordController.text,
                      );

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đăng nhập thành công')),
                        );

                        // Lấy token từ SharedPreferences
                        final token = await SharedPrefService.getToken();
                        print('Token lấy từ SharedPreferences: $token');

                        // Chuyển tới trang Welcome sau khi đăng nhập thành công
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomeView(),
                          ),
                        );
                      } else {
                        // Hiển thị lỗi nếu đăng nhập thất bại
                        final errorData = jsonDecode(response.body);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Đăng nhập thất bại: ${errorData['error'] ?? 'Vui lòng thử lại.'}'),
                          ),
                        );
                      }
                    } catch (error) {
                      LoadingHelper.hideLoadingOverlay();
                      print("Có lỗi xảy ra. Vui lòng thử lại: $error");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Có lỗi xảy ra. Vui lòng thử lại. ')),
                      );
                    } finally {
                      // Ẩn loading sau khi quá trình xử lý hoàn tất
                      LoadingHelper.hideLoadingOverlay();
                    }
                  },
                ),

                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/facebook.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

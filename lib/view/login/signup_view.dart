import 'package:fitness/api/auth_controllers.dart';
import 'package:fitness/api/api_service.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common/assets.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/common_widget/validate/validator.dart';
import 'package:fitness/view/login/complete_profile_view.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  bool _isObscured = true; // Trạng thái hiển thị mật khẩu
  final AuthControllers _authControllers = AuthControllers();

  @override
  void dispose() {
    _authControllers.firstNameController.dispose();
    _authControllers.lastNameController.dispose();
    _authControllers.emailController.dispose();
    _authControllers.passwordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    String? validationError = AuthValidator.validateFirstName(
            _authControllers.firstNameController.text) ??
        AuthValidator.validateLastName(
            _authControllers.lastNameController.text) ??
        AuthValidator.validateEmail(_authControllers.emailController.text) ??
        AuthValidator.validatePassword(
            _authControllers.passwordController.text);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    // Nếu tất cả đều hợp lệ, chuyển sang màn hình tiếp theo
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteProfileView(
          firstName: _authControllers.firstNameController.text,
          lastName: _authControllers.lastNameController.text,
          email: _authControllers.emailController.text,
          password: _authControllers.passwordController.text,
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured; // Chuyển đổi trạng thái hiển thị mật khẩu
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
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
                  "Create an Account",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextFormField(
                  controller: _authControllers.firstNameController,
                  hitText: "First Name",
                  icon: TImages.userText,

                  // errorText: firstNameError,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextFormField(
                  controller: _authControllers.lastNameController,
                  hitText: "Last Name",
                  icon: TImages.userText,
                  // validator: ,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextFormField(
                  controller: _authControllers.emailController,
                  hitText: "Email",
                  icon: TImages.email,
                  keyboardType: TextInputType.emailAddress,
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerm of Use",
                        style: TextStyle(color: TColor.gray, fontSize: 10),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundButton(title: "Register", onPressed: _validateAndSubmit),
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
                            builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
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

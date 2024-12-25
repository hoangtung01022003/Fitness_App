import 'package:fitness/api/auth_controllers.dart';
import 'package:fitness/api/api_service.dart';
import 'package:fitness/common/assets.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/date/date_year.dart';
import 'package:fitness/common_widget/loading_helper.dart';
import 'package:fitness/common_widget/validate/validator.dart';
import 'package:fitness/view/login/what_your_goal_view.dart';
import 'package:flutter/material.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class CompleteProfileView extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const CompleteProfileView({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final ProfileControllers _profileControllers = ProfileControllers();
  final ApiService _authService = ApiService();

  @override
  void dispose() {
    _profileControllers.genderController.dispose();
    _profileControllers.dateController.dispose();
    _profileControllers.heightController.dispose();
    _profileControllers.weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: media.width * 0.05),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(height: media.width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      // Dropdown cho giới tính
                      Container(
                        decoration: BoxDecoration(
                          color: TColor.lightGray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Image.asset(
                                TImages.gender,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                color: TColor.gray,
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: ["Male", "Female"]
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                color: TColor.gray,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _profileControllers.selectedGender =
                                          value as String?;
                                      _profileControllers
                                              .genderController.text =
                                          _profileControllers.selectedGender ??
                                              '';
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    _profileControllers.selectedGender ??
                                        "Choose Gender",
                                    style: TextStyle(
                                      color:
                                          _profileControllers.selectedGender ==
                                                  null
                                              ? TColor.gray
                                              : TColor.black,
                                      fontSize:
                                          _profileControllers.selectedGender ==
                                                  null
                                              ? 12
                                              : 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),

                      SizedBox(height: media.width * 0.04),

                      // Trường ngày sinh
                      Date_year(
                        txtDate: _profileControllers.dateController,
                        selectedDate: _profileControllers.selectedDate,
                        hintText: "Date of Birth",
                      ),
                      SizedBox(height: media.width * 0.04),

                      // Trường cân nặng
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextFormField(
                              controller: _profileControllers.weightController,
                              hitText: "Your Weight",
                              icon: TImages.weight,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: TColor.secondaryG),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: media.width * 0.04),

                      // Trường chiều cao
                      Row(
                        children: [
                          Expanded(
                            child: RoundTextFormField(
                              controller: _profileControllers.heightController,
                              hitText: "Your Height",
                              icon: TImages.height,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: TColor.secondaryG),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: media.width * 0.07),

                      // Nút tiếp theo
                      RoundButton(
                        title: "Next >",
                        onPressed: () async {
                          // Hiển thị loading
                          LoadingHelper.showLoadingOverlay(context);

                          // Lấy thông tin từ các TextEditingController
                          String gender =
                              _profileControllers.genderController.text;
                          String dateOfBirthString =
                              _profileControllers.dateController.text;
                          String heightString =
                              _profileControllers.heightController.text;
                          String weightString =
                              _profileControllers.weightController.text;

                          // Chuyển đổi chuỗi ngày sinh thành DateTime
                          DateTime? dateOfBirth;
                          try {
                            if (dateOfBirthString.isNotEmpty) {
                              dateOfBirth = DateTime.parse(dateOfBirthString);
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Ngày sinh không hợp lệ.')),
                            );
                            LoadingHelper
                                .hideLoadingOverlay(); // Ẩn loading nếu có lỗi
                            return;
                          }

                          // Chuyển đổi chiều cao và cân nặng từ String sang double
                          double? height = double.tryParse(heightString);
                          double? weight = double.tryParse(weightString);

                          // Validate dữ liệu trước khi gửi
                          String? validationError = ProfileValidator
                                  .validateGender(gender) ??
                              ProfileValidator.validateDateOfBirth(
                                  dateOfBirth) ??
                              ProfileValidator.validateHeight(height) ??
                              ProfileValidator.validateWeight(weight) ??
                              AuthValidator.validateFirstName(
                                  widget.firstName) ??
                              AuthValidator.validateLastName(widget.lastName) ??
                              AuthValidator.validateEmail(widget.email) ??
                              AuthValidator.validatePassword(widget.password);

                          if (validationError != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(validationError)),
                            );
                            LoadingHelper
                                .hideLoadingOverlay(); // Ẩn loading nếu có lỗi validate
                            return;
                          }

                          try {
                            // Gọi hàm đăng ký với thông tin từ cả hai màn hình
                            await _authService.submitRegister(
                              context,
                              widget.firstName,
                              widget.lastName,
                              widget.email,
                              widget.password,
                              gender,
                              dateOfBirthString,
                              weight!,
                              height!,
                            );

                            // Nếu thành công, chuyển sang màn hình tiếp theo
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WhatYourGoalView(),
                              ),
                            );
                          } catch (error) {
                            // Xử lý lỗi khi đăng ký thất bại
                            print('Đăng ký không thành công: $error');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Đăng ký không thành công: $error')),
                            );
                          } finally {
                            // Ẩn loading sau khi hoàn tất
                            LoadingHelper.hideLoadingOverlay();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

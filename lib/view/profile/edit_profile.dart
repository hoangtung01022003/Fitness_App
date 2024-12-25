import 'package:fitness/api/api_service.dart';
import 'package:fitness/api/auth_controllers.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common/assets.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/date/date_year.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/common_widget/success_screens/success_screen.dart';
import 'package:fitness/common_widget/validate/validator.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Map<String, dynamic> userInfo = {};
  ProfileControllers _profileControllers = ProfileControllers();
//
  @override
  void initState() {
    super.initState();
    loadUserInfoFromCache();
  }

  // Lấy dữ liệu từ cache và cập nhật UI
  Future<void> loadUserInfoFromCache() async {
    final cachedInfo = await SharedPrefService.getCachedUserInfo();
    if (cachedInfo != null) {
      if (mounted) {
        setState(() {
          userInfo = cachedInfo;
          _profileControllers.dateController.text =
              userInfo['date_of_birth'] ?? '';
          _profileControllers.genderController.text = userInfo['gender'] ?? '';
          _profileControllers.heightController.text =
              userInfo['height'].toString();
          _profileControllers.weightController.text =
              userInfo['weight'].toString();
          print(userInfo);
          print(cachedInfo);
        });
      }
    } else {
      print("Không có thông tin người dùng trong cache");
    }
  }

  @override
  void dispose() {
    // Giải phóng TextEditingController khi không dùng nữa
    _profileControllers.dateController.dispose();
    _profileControllers.genderController.dispose();
    _profileControllers.heightController.dispose();
    _profileControllers.weightController.dispose();
    super.dispose();
  }

  final ApiService _apiService = ApiService();
  // Hàm gọi khi người dùng thực hiện cập nhật
  Future<void> updateUserInformation(
      String gender, String date_of_birth, double weight, double height) async {
    final updatedData = {
      "gender": gender,
      "date_of_birth": date_of_birth,
      "weight": weight,
      "height": height,
    };

    final success = await _apiService.updateUserInfo(updatedData);
    if (success) {
      await SharedPrefService.cacheUserInfo(updatedData); // Lưu vào cache
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(
            text1: 'Edited information successfully',
          ),
        ),
      );
      print(
          "Thông tin người dùng đã được cập nhật thành công và lưu vào cache");
    }
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
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: TColor.lightGray,
                            borderRadius: BorderRadius.circular(15)),
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
                                )),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: _profileControllers
                                          .genderController.text.isNotEmpty
                                      ? _profileControllers
                                              .genderController.text[0]
                                              .toUpperCase() +
                                          _profileControllers
                                              .genderController.text
                                              .substring(1)
                                              .toLowerCase()
                                      : null, // Đảm bảo chỉ sử dụng "Male" hoặc "Female"
                                  items: ["Male", "Female"]
                                      .map((name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                  color: TColor.gray,
                                                  fontSize: 14),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _profileControllers.selectedGender =
                                          value ??
                                              ''; // Cập nhật giá trị đã chọn
                                      _profileControllers
                                              .genderController.text =
                                          _profileControllers.selectedGender ??
                                              '';
                                    });
                                  },
                                  isExpanded: true,
                                  hint: Text(
                                    // _profileControllers.selectedGender ??
                                    "Choose Gender",
                                    style: TextStyle(
                                        color: _profileControllers
                                                    .selectedGender ==
                                                null
                                            ? TColor.gray
                                            : TColor.black,
                                        fontSize: _profileControllers
                                                    .selectedGender ==
                                                null
                                            ? 12
                                            : 14),
                                  ),
                                  //  value: selectedGender,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ),
                      
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      Date_year(
                        txtDate: _profileControllers.dateController,
                        selectedDate: _profileControllers.selectedDate,
                        hintText: '"Date of Birth"',
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
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
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
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
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: TColor.secondaryG,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                        title: "Confirm",
                        onPressed: () async {
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
                            return;
                          }

                          // Chuyển đổi chiều cao và cân nặng từ String sang double
                          double? height = double.tryParse(heightString);
                          double? weight = double.tryParse(weightString);

                          // Validate dữ liệu trước khi gửi
                          String? validationError =
                              ProfileValidator.validateGender(gender) ??
                                  ProfileValidator.validateDateOfBirth(
                                      dateOfBirth) ??
                                  ProfileValidator.validateHeight(height) ??
                                  ProfileValidator.validateWeight(weight);

                          if (validationError != null) {
                            // Nếu có lỗi, hiển thị thông báo lỗi
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(validationError)),
                            );
                            return;
                          }

                          try {
                            // Gọi hàm cập nhật thông tin người dùng
                            await updateUserInformation(
                                gender, dateOfBirthString, weight!, height!);

                            // Hiển thị thông báo cập nhật thành công
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Cập nhật thông tin thành công')),
                            );
                          } catch (error) {
                            print('Cập nhật không thành công: $error');
                            // Xử lý lỗi khi cập nhật thất bại
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Cập nhật không thành công: $error')),
                            );
                          }
                        },
                      )
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

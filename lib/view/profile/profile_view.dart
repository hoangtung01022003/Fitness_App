import 'package:fitness/api/api_service.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common_widget/calculate_age.dart';
import 'package:fitness/common_widget/values/textArr.dart';
import 'package:fitness/view/login/login_view.dart';
import 'package:flutter/material.dart';

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;
  Textarr textarr = Textarr();
  final ApiService _apiService = ApiService();
  String fullName = '';
  int weight = 0;
  int height = 0;
  int age = 0;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Gọi hàm để tải dữ liệu người dùng
  }

  // Hàm này sẽ tải dữ liệu người dùng
  Future<void> loadUserData() async {
    // Bước 1: Tải dữ liệu từ cache
    await loadUserInfoFromCache();

    // Bước 2: Nếu không có dữ liệu trong cache, gọi API để tải dữ liệu và lưu vào cache
    if (fullName.isEmpty) {
      await SharedPrefService.fetchAndCacheUserInfo(_apiService);
      await loadUserInfoFromCache(); // Tải lại dữ liệu từ cache sau khi lưu
    }
  }

  // Hàm để tải thông tin từ cache
  Future<void> loadUserInfoFromCache() async {
    try {
      final cachedUserInfo = await SharedPrefService.getCachedUserInfo();
      if (cachedUserInfo != null) {
        setState(() {
          fullName =
              '${cachedUserInfo['first_name'] ?? ''} ${cachedUserInfo['last_name'] ?? ''}';
          
          height = cachedUserInfo['height'] ?? 0.0;
          weight = cachedUserInfo['weight'] ?? 0.0;
          age = calculateAge(cachedUserInfo['date_of_birth'] ?? '');
          // Các trường khác nếu cần
        });
        print("Thông tin người dùng đã được tải từ cache");
      } else {
        print("Không có thông tin người dùng trong cache");
      }
    } catch (e) {
      print("Lỗi khi tải thông tin từ cache: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        // leading: IconButton(
        //   // icon: Icon(Icons.arrow_back, color: TColor.gray),
        //   onPressed: () {
        //     Navigator.pop(context); // Quay lại màn hình trước
        //   },
        // ),
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/img/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/img/u2.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '$fullName',
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Lose a Fat Program",
                          style: TextStyle(
                            color: TColor.gray,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.bgGradient,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/edit_profile',
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "$height",
                      subtitle: "Height",
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "$weight",
                      subtitle: "Weight",
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "$age",
                      subtitle: "Age",
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: textarr.accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = textarr.accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notification",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 30,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/img/p_notification.png",
                                height: 15, width: 15, fit: BoxFit.contain),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "Pop-up Notification",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            
                          ]),
                    )
                  
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other",
                      style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: textarr.otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = textarr.otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {},
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                title: "Logout",
                onPressed: () async {
                  try {
                    // Call API to logout with stored token
                    final response = await _apiService.logoutUser();

                    print(
                        'Response status: ${response.statusCode}'); // Print status code
                    print(
                        'Response body: ${response.body}'); // Log the response body

                    if (response.statusCode == 200) {
                      // If logout is successful, remove token from SharedPreferences
                      await SharedPrefService
                          .removeToken(); // Clear token from SharedPreferences

                      // Redirect user to login page
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginView(), // Navigate to Login
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    } else {
                      // Show error if status code is not 200
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đăng xuất thất bại. Mã trạng thái: ${response.statusCode}',
                          ),
                        ),
                      );
                    }
                  } catch (error) {
                    // Handle error when unable to connect to API or other errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Có lỗi xảy ra khi đăng xuất: $error')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

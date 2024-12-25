import 'package:fitness/api/api_service.dart';
import 'package:fitness/api/auth_controllers.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/api/target_api_service.dart';
import 'package:fitness/common/assets.dart';
import 'package:fitness/common_widget/date/date_year.dart';
import 'package:fitness/common_widget/loading_helper.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:fitness/common_widget/validate/validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTarget extends StatefulWidget {
  const AddTarget({Key? key}) : super(key: key);

  @override
  State<AddTarget> createState() => _AddTargetState();
}

class _AddTargetState extends State<AddTarget> {
  final ProfileControllers _profileControllers = ProfileControllers();
  final TargetApiService _targetApiService = TargetApiService();
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Set Your Target",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: media.height * 0.03),
                // Goal Type
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: "Goal Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    "Lose Weight",
                    "Height Increase",
                    "Muscle Mass Increase",
                    "Abs"
                  ]
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _profileControllers.goalTypeController.text = value ?? '';
                    });
                  },
                  value: _profileControllers.goalTypeController.text.isEmpty
                      ? null
                      : _profileControllers.goalTypeController.text,
                ),
                SizedBox(height: media.height * 0.02),
                // Target Value
                TextFormField(
                  controller: _profileControllers.targetValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Target Value",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: media.height * 0.02),
                // Unit
                RoundTextFormField(
                  controller: _profileControllers.unitController,
                  hitText: "Unit (e.g., kg, cm)",
                  icon: TImages.height,
                  // keyboardType: TextInputType.number,
                ),
                SizedBox(height: media.height * 0.02),
                // Start Date
                Date_year(
                  txtDate: _profileControllers.dateStart,
                  selectedDate: _profileControllers.selectedDate,
                  hintText: '"Start Date (YYYY-MM-DD)"',
                ),
                SizedBox(height: media.height * 0.02),
                // Target Date
                Date_year(
                  txtDate: _profileControllers.dateEnd,
                  selectedDate: _profileControllers.selectedDate,
                  hintText: '"Target Date (YYYY-MM-DD)"',
                ),
                SizedBox(height: media.height * 0.04),
                // Confirm Button
                RoundButton(
                  title: "Next >",
                  onPressed: () async {
                    // Hiển thị loading
                    LoadingHelper.showLoadingOverlay(context);

                    // Lấy token từ SharedPreferences (tạm thời lưu trong bộ nhớ cache)
                    String? token = await SharedPrefService.getToken();

                    // Kiểm tra nếu không có token
                    if (token == null || token.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token is not availablesssss')),
                      );
                      LoadingHelper.hideLoadingOverlay();
                      return;
                    }

                    // Tiếp tục xử lý các bước như lấy dữ liệu từ form và gửi yêu cầu API
                    String goalType =
                        _profileControllers.goalTypeController.text;
                    String targetValuesString =
                        _profileControllers.targetValueController.text;
                    String unit = _profileControllers.unitController.text;
                    String start_date_string =
                        _profileControllers.dateStart.text;
                    String target_date_string =
                        _profileControllers.dateEnd.text;

                    DateTime? start_date;
                    DateTime? target_date;
                    try {
                      if (start_date_string.isNotEmpty &&
                          target_date_string.isNotEmpty) {
                        start_date = DateTime.parse(start_date_string);
                        target_date = DateTime.parse(target_date_string);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ngày không hợp lệ.')),
                      );
                      LoadingHelper.hideLoadingOverlay();
                      return;
                    }

                    double? target_value = double.tryParse(targetValuesString);

                    if (target_value == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Giá trị mục tiêu không hợp lệ.')),
                      );
                      LoadingHelper.hideLoadingOverlay();
                      return;
                    }

                    String? validationError =
                        TargetValidator.validateGoalType(goalType) ??
                            TargetValidator.validateTargetValue(target_value) ??
                            TargetValidator.validateUnit(unit) ??
                            TargetValidator.validateStartDate(start_date) ??
                            TargetValidator.validateTargetDate(
                                start_date, target_date);

                    if (validationError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(validationError)),
                      );
                      LoadingHelper.hideLoadingOverlay();
                      return;
                    }

                    try {
                      // Gọi API và truyền token vào header cho yêu cầu xác thực
                      await _targetApiService.addTarget(
                        goalType,
                        target_value.toString(),
                        unit,
                        start_date?.toIso8601String() ?? "",
                        target_date?.toIso8601String() ?? "",
                      );

                      // Nếu thành công, quay lại màn hình trước
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Add target success.')),
                      );
                    } catch (error) {
                      print('Đăng ký không thành công: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Đăng ký không thành công: $error')),
                      );
                    } finally {
                      LoadingHelper.hideLoadingOverlay();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthControllers {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
}

class ProfileControllers {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedGender;
  // String formatDate(String date) {
  //   final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
  //   final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  //   final DateTime parsedDate = inputFormat.parse(date);
  //   return outputFormat.format(parsedDate);
  // }

  String? validateFields() {
    if (selectedGender == null || selectedGender!.isEmpty) {
      return "Please select your gender";
    }
    if (dateController.text.isEmpty) {
      return "Please enter your date of birth";
    }
    if (weightController.text.isEmpty) {
      return "Please enter your weight";
    }
    if (heightController.text.isEmpty) {
      return "Please enter your height";
    }
    return null; // Không có lỗi
  }
}

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
  final TextEditingController goalTypeController = TextEditingController();
  final TextEditingController targetValueController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController targetDateController = TextEditingController();
  final TextEditingController dateStart = TextEditingController();
  final TextEditingController dateEnd = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedGender;
  String? selectedGoalType;
}

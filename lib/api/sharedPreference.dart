import 'dart:convert';

import 'package:fitness/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String _userTokenKey = 'userToken';
  static const String _isLoggedInKey =
      'isLoggedIn'; // Thêm key cho trạng thái đăng nhập
  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String userInfoKey = 'user_info';

  ApiService _apiService = ApiService();

  // Hàm lưu token vào SharedPreferences
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, token);
    print('Token đã lưu: $token');
  }

  static Future<void> cacheUserInfo(Map<String, dynamic> userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson =
        jsonEncode(userInfo); // Chuyển đổi dữ liệu thành chuỗi JSON
    await prefs.setString(
        userInfoKey, userInfoJson); // Lưu vào SharedPreferences
    print("Đã lưu thông tin người dùng: $userInfoJson");
  }

  static Future<Map<String, dynamic>?> getCachedUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString(userInfoKey);

    if (userInfoJson != null) {
      try {
        // Giải mã chuỗi JSON thành Map
        return jsonDecode(userInfoJson) as Map<String, dynamic>;
      } catch (e) {
        print("Lỗi khi giải mã JSON: $e");
        return null;
      }
    } else {
      print("Không có thông tin người dùng trong cache");
      return null;
    }
  }

  // Hàm xóa thông tin người dùng trong SharedPreferences khi đăng xuất
  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userInfoKey); // Xóa dữ liệu từ SharedPreferences
  }

  static Future<void> fetchAndCacheUserInfo(ApiService apiService) async {
    final userInfo = await apiService.getUserInfo();
    if (userInfo != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(userInfoKey, jsonEncode(userInfo));
    }
  }

  // Hàm lấy token từ SharedPreferences
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_userTokenKey);
    print('Token lấy được: $token');
    return token;
  }

  // Hàm xóa token khỏi SharedPreferences khi đăng xuất
  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTokenKey);
    await prefs.remove(_isLoggedInKey); // Xóa trạng thái đăng nhập
    await SharedPrefService.clearUserInfo();
    print('Token đã xóa');
  }

  // Hàm lưu trạng thái đăng nhập
  static Future<void> setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
    print('Trạng thái đăng nhập đã lưu: $isLoggedIn');
  }

  // Hàm lấy trạng thái đăng nhập
  static Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ??
        false; // Mặc định là false nếu chưa có
  }

  // Hàm lưu trạng thái lần đầu mở ứng dụng
  static Future<void> setFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false); // Đặt là false sau khi đã mở
  }

  // Hàm kiểm tra trạng thái lần đầu mở ứng dụng
  static Future<bool> isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ??
        true; // Mặc định là true nếu chưa có
  }

  static Future<double?> calculateBMIFromCache() async {
    final userInfo = await SharedPrefService.getCachedUserInfo();
    if (userInfo != null) {
      final double height = userInfo['height'] ?? 0.0; // Lấy chiều cao
      final double weight = userInfo['weight'] ?? 0.0; // Lấy cân nặng

      // Kiểm tra chiều cao không bằng 0 để tránh lỗi chia cho 0
      if (height > 0) {
        return weight / ((height / 100) * (height / 100));
      }
    }
    return null; // Trả về null nếu không tính được
  }
}

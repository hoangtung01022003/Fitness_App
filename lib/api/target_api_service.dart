import 'dart:convert';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/model/target.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Đảm bảo import đúng thư viện http
import 'package:fitness/config/constants.dart';

class TargetApiService {
  // Đối tượng http đã được khởi tạo
  final http.Client _client = http.Client(); // Khởi tạo http client

  Future<bool> addTarget(String goalType, String targetValue, String unit,
      String startDate, String targetDate) async {
    String? token = await SharedPrefService.getToken();

    // Kiểm tra nếu không có token
    if (token == null) {
      print("OK");
      return false;
    }
    try {
      final Map<String, dynamic> targetData = {
        'goal_type': goalType,
        'target_value': targetValue,
        'unit': unit,
        'start_date': startDate,
        'target_date': targetDate,
      };

      // Gửi yêu cầu POST tới API
      final response = await _client.post(
        Uri.parse('$baseUrl/targets'),
        body: jsonEncode(targetData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Nếu cần token xác thực
        },
      );

      if (response.statusCode == 201) {
        return true; // Thành công
      } else {
        return false; // Thất bại
      }
    } catch (e) {
      print('Error occurred while adding target: $e');
      return false; // Lỗi khi gửi yêu cầu
    }
  }

  Future<List<Map<String, dynamic>>> fetchTargets() async {
    String? token = await SharedPrefService.getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/targets'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse JSON từ response body
        final data = jsonDecode(response.body) as List;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch targets');
      }
    } catch (e) {
      throw Exception('Error fetching targets: $e');
    }
  }

  Future<void> deleteTarget(int id) async {
    final url = Uri.parse("$baseUrl/targets/$id");
    String? token = await SharedPrefService.getToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Thêm token xác thực
          'Content-Type': 'application/json',
        },
      );
      // Kiểm tra mã trạng thái HTTP
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Target deleted successfully');
        // Cập nhật giao diện nếu cần (như xóa item khỏi danh sách)
      } else {
        // Xử lý lỗi khi phản hồi không thành công
        if (response.body.isNotEmpty) {
          final errorMessage = jsonDecode(response.body)['message'];
          throw Exception('Failed to delete target: $errorMessage');
        } else {
          throw Exception('Failed to delete target: ${response.statusCode}');
        }
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}

import 'dart:convert';
import 'package:fitness/api/sharedPreference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiService {
  // final String tokens;
  final String _baseUrl =
      'http://127.0.0.1:8000/api'; // Tạo URL cơ bản dùng chung
// ApiService(this.tokens);
  // Hàm lấy token
  Future<String?> _getToken() async {
    return await SharedPrefService.getToken();
  }

  // Hàm tạo headers chung, có thể thêm token nếu cần
  Future<Map<String, String>> _getHeaders({bool includeToken = false}) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if (includeToken) {
      String? token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Hàm login
  Future<http.Response> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json', // Tiêu đề cho yêu cầu
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['access_token']; // Chú ý sửa thành 'access_token'

        // Lưu token vào SharedPreferences
        await SharedPrefService.saveToken(token);
        final userInfo = await getUserInfo();
        await SharedPrefService.cacheUserInfo(userInfo!);
        await SharedPrefService();
        return response; // Trả về phản hồi thành công
      } else {
        // Nếu không thành công, ném lỗi với thông báo từ server
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Đăng nhập không thành công: ${errorData['error'] ?? 'Không có thông báo'}');
      }
    } catch (error) {
      throw Exception('Lỗi khi đăng nhập: $error');
    }
  }

  // Hàm logout
  Future<http.Response> logoutUser() async {
    final token = await SharedPrefService.getToken();
    print('Token trước khi đăng xuất: $token'); // In ra giá trị token
    if (token == null) {
      print('Không tìm thấy token');
      throw Exception('Người dùng chưa đăng nhập');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Thêm Content-Type
        },
      );

      if (response.statusCode == 200) {
        // Xóa token sau khi đăng xuất
        await SharedPrefService.removeToken();
        print('Đăng xuất thành công');
      } else {
        print('Đăng xuất thất bại với mã trạng thái: ${response.statusCode}');
      }

      return response;
    } catch (error) {
      throw Exception('Lỗi khi đăng xuất: $error');
    }
  }

  Future<http.Response> submitRegister(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
    String gender,
    String dateOfBirth,
    double weight,
    double height,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'), // Sử dụng endpoint đăng ký
        headers: await _getHeaders(), // Không cần token cho đăng ký
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'gender': gender,
          'date_of_birth': dateOfBirth,
          'weight': weight,
          'height': height,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String token = data['token']; // Lấy token sau khi đăng ký thành công

        // Lưu token vào SharedPreferences
        await SharedPrefService.saveToken(token);

        print('Đăng ký thành công');
        // Điều hướng sang màn hình tiếp theo hoặc trang chủ của ứng dụng
      } else {
        print('Đăng ký thất bại: ${response.body}');
      }

      return response;
    } catch (error) {
      throw Exception('Lỗi khi đăng ký: $error');
    }
  }

  // Hàm lấy thông tin người dùng
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      // Lấy token từ SharedPreferences
      final token = await SharedPrefService.getToken();
      if (token == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      // Gửi yêu cầu HTTP GET tới endpoint API để lấy thông tin người dùng
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/user/profile'), // Đảm bảo endpoint này đúng với API của bạn
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Kiểm tra mã phản hồi HTTP
      if (response.statusCode == 200) {
        // Giải mã JSON nếu phản hồi thành công
        final data = jsonDecode(response.body);

        // Kiểm tra và lấy các trường cần thiết từ phản hồi JSON
        return {
          'first_name': data['first_name'] ?? '',
          'last_name': data['last_name'] ?? '',
          'gender': data['gender'] ?? '',
          'weight': data['weight'] ?? 0.0,
          'height': data['height'] ?? 0.0,
          'date_of_birth': data['date_of_birth'] ?? '',
          // Bổ sung thêm các trường khác nếu có
        };
      } else {
        // Giải mã và xử lý thông báo lỗi nếu phản hồi không thành công
        final errorData = jsonDecode(response.body);
        throw Exception(
            'Lấy thông tin người dùng không thành công: ${errorData['error'] ?? 'Không có thông báo'}');
      }
    } catch (error) {
      throw Exception('Lỗi khi lấy thông tin người dùng: $error');
    }
  }

  Future<bool> updateUserInfo(Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$_baseUrl/user/profile/update');
    try {
      // Lấy token từ SharedPreferences
      final token = await SharedPrefService.getToken();

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Sử dụng token từ SharedPreferences
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print("Thông tin người dùng đã được cập nhật thành công");
        return true;
      } else {
        // In mã lỗi và thông báo lỗi từ API
        print("Cập nhật thông tin người dùng thất bại: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi cập nhật thông tin người dùng: $e");
      return false;
    }
  }
}

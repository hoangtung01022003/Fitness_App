import 'dart:io';
import 'package:intl/intl.dart'; // Thư viện để định dạng thời gian
import 'package:path/path.dart' as path;
import 'package:fitness/common/colo_extension.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryImages extends StatefulWidget {
  const GalleryImages({super.key});

  @override
  State<GalleryImages> createState() => _GalleryImagesState();
}

class _GalleryImagesState extends State<GalleryImages> {
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<List<Map<String, String>>> getSavedImagesByLatestDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedImages = prefs.getStringList('saved_image_paths') ?? [];

      // Nếu danh sách ảnh trống thì trả về danh sách rỗng
      if (savedImages.isEmpty) return [];

      // Tìm ngày lưu mới nhất
      String latestDate = '';
      for (var imageData in savedImages) {
        final parts = imageData.split(',');
        if (parts.length < 2) continue; // Bỏ qua dữ liệu không hợp lệ
        final timestamp = parts[1];

        // Chuyển timestamp thành ngày định dạng dd-MM-yyyy
        final formattedDate =
            DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));

        // Cập nhật ngày mới nhất
        if (latestDate.isEmpty || formattedDate.compareTo(latestDate) > 0) {
          latestDate = formattedDate;
        }
      }

      // Lọc ảnh theo ngày lưu mới nhất
      return savedImages
          .map((imageData) {
            final parts = imageData.split(',');
            if (parts.length < 2) return null; // Bỏ qua dữ liệu không hợp lệ

            final rawPath = parts[0]; // Đường dẫn thô từ dữ liệu
            final timestamp = parts[1];

            // Chuẩn hóa đường dẫn (loại bỏ phần dư nếu có)
            final correctedPath = rawPath.contains('app_flutter/data')
                ? rawPath.replaceAll('/app_flutter/data', '')
                : rawPath;

            final formattedDate =
                DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));

            return {
              'path': path.normalize(correctedPath), // Chuẩn hóa đường dẫn
              'timestamp': formattedDate, // Đảm bảo định dạng là dd-MM-yyyy
            };
          })
          .where((image) =>
              image != null && image['timestamp'] == latestDate) // Loại bỏ null
          .cast<Map<String, String>>() // Đảm bảo kiểu dữ liệu chính xác
          .toList();
    } catch (e) {
      print('Lỗi khi lấy thông tin ảnh và thời gian: $e');
      return [];
    }
  }

  // Hàm yêu cầu quyền truy cập bộ nhớ
  Future<void> _requestPermissions() async {
    try {
      // Kiểm tra trạng thái quyền hiện tại
      PermissionStatus status = await Permission.storage.status;

      if (status.isDenied ||
          status.isRestricted ||
          status.isPermanentlyDenied) {
        // Nếu quyền chưa được cấp, yêu cầu quyền
        PermissionStatus newStatus = await Permission.storage.request();
        if (!newStatus.isGranted) {
          print("Quyền không được cấp.");
        } else {
          print("Quyền đã được cấp.");
        }
      } else if (status.isGranted) {
        print("Quyền đã có sẵn.");
      }
    } catch (e) {
      print("Lỗi khi yêu cầu quyền: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Permission.storage.request();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2, // Chỉ một item để chứa ảnh
      itemBuilder: (context, index) {
        return FutureBuilder<List<Map<String, String>>>(
          future: getSavedImagesByLatestDate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Hiển thị loader trong lúc lấy dữ liệu
            } else if (snapshot.hasError) {
              return Text('Lỗi: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Không có ảnh đã lưu.');
            } else {
              var savedImages = (snapshot.data as List<Map<String, String>>?)
                      ?.where((image) =>
                          image['path'] != null &&
                          image['path']!.isNotEmpty) // Lọc các mục hợp lệ
                      .map((image) {
                    // Chuẩn hóa đường dẫn nếu cần
                    final correctedPath = image['path']!
                            .contains('app_flutter/data')
                        ? image['path']!.replaceFirst(
                            '/data/user/0/com.codeforany.fitness/app_flutter',
                            '')
                        : image['path']!;
                    return {
                      ...image,
                      'path':
                          path.normalize(correctedPath), // Chuẩn hóa đường dẫn
                    };
                  }).toList() ??
                  []; // Trả về danh sách rỗng nếu null

              print('Snapshot Data: ${snapshot.data}');
              // Lấy thời gian lưu của ảnh
              String latestDate = savedImages.isNotEmpty
                  ? savedImages.first['timestamp'] ?? 'N/A'
                  : 'N/A';

              if (savedImages.isEmpty) {
                // Nếu không có ảnh, hiển thị icon thay thế
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Lưu vào ngày: $latestDate', // Hiển thị ngày lưu ảnh
                        style: TextStyle(color: TColor.gray, fontSize: 12),
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.photo_size_select_actual, // Icon ảnh thay thế
                        size: 100,
                        color: TColor.lightGray,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Lưu vào ngày: $latestDate', // Hiển thị ngày lưu ảnh
                      style: TextStyle(color: TColor.gray, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: savedImages.length,
                      itemBuilder: (context, index) {
                        var image = savedImages[index];
                        String imagePath = image['path'] ?? '';

// In đường dẫn ảnh để kiểm tra
                        // print('Image Path: $imagePath');

// Kiểm tra tệp tin có tồn tại không

                        final file = File(image['path']!);
                        if (file.existsSync()) {
                          print('Hiển thị ảnh từ: ${file.path}');
                        } else {
                          print('Không tìm thấy ảnh tại: ${file.path}');
                        }
                        if (!file.existsSync()) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons
                                  .broken_image, // Hiển thị icon khi không tìm thấy ảnh
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                file, // Hiển thị ảnh từ đường dẫn
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

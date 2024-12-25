import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fitness/api/sharedPreference.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  Future<void>? _initializeControllerFuture;
  bool _isRearCamera = true;
  bool _isFlashOn = false;
  XFile? _capturedImage; // Để lưu trữ ảnh vừa chụp
  bool _isFlashing = false; // Để điều khiển hiệu ứng nháy màn hình
  List<String?> capturedImages =
      List<String?>.filled(4, null); // 4 vị trí, mặc định là null

  @override
  void initState() {
    super.initState();
    // _initializeCameras();
    _requestPermissionAndInitialize();
  }

  Future<void> _requestPermissionAndInitialize() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCameras();
    } else {
      print("Camera permission denied");
    }
  }

  Future<void> _initializeCameras() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _initializeCamera(_isRearCamera ? _cameras!.first : _cameras!.last);
    }
  }

  void _initializeCamera(CameraDescription cameraDescription) {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController!.initialize();
    setState(() {}); // Cập nhật UI khi khởi tạo xong
  }

  void _switchCamera() {
    if (_cameras != null && _cameras!.isNotEmpty) {
      _isRearCamera = !_isRearCamera;
      _initializeCamera(_isRearCamera ? _cameras!.first : _cameras!.last);
    }
  }

  void _toggleFlash() async {
    if (_cameraController != null) {
      _isFlashOn = !_isFlashOn;
      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    try {
      if (!capturedImages.contains(null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã chụp đủ 4 ảnh!')),
        );
        return;
      }

      await _initializeControllerFuture;

      // Bắt đầu chụp ảnh (nhanh gọn)
      final XFile? image = await _cameraController?.takePicture();

      if (image != null) {
        final int emptyIndex = capturedImages.indexOf(null);

        if (emptyIndex != -1) {
          // Lưu vào danh sách ngay lập tức
          capturedImages[emptyIndex] = image.path;
          // Cập nhật trạng thái UI
          setState(() {});
        }

        // Kích hoạt hiệu ứng nháy màn hình
        _triggerFlashEffect();
      }
    } catch (e) {
      print('Lỗi khi chụp ảnh: $e');
    }
  }

  void _triggerFlashEffect() {
    setState(() {
      _isFlashing = true;
    });

    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        _isFlashing = false;
      });
    });
  }

  bool _canSave() {
    // Kiểm tra xem tất cả vị trí đã có ảnh chưa
    return capturedImages.every((image) => image != null);
  }

  void _showImageDialog(String imagePath, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.file(File(imagePath)), // Hiển thị ảnh trong dialog
        actions: <Widget>[
          TextButton(
            child: Text('Close'), // Nút đóng dialog
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
          ),
        ],
      ),
    );
  }

  void _saveAllImages() async {
    try {
      // Giả sử capturedImages là một List<String> chứa danh sách các tên file ảnh
      List<String> imageFileNames = capturedImages.whereType<String>().toList();

      if (imageFileNames.isNotEmpty) {
        // Lưu tất cả ảnh cùng một lúc
        await SharedPrefService.saveImagePathWithTimestamp(imageFileNames);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Images have been saved!')),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
      } else {
        // Không có ảnh để lưu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No images to save!')),
        );
      }
    } catch (e) {
      print("Error saving images: $e");
    }
  }

  void _cancelImage() {
    setState(() {
      _capturedImage = null; // Hủy ảnh, quay về camera preview
    });
  }

  // @override
  // void dispose() {
  //   // capturedImages = List<String?>.filled(
  //   //     4, null); // Làm sạch danh sách    _cameraController?.dispose();
  //   print("đã xoá");
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonSize =
        screenWidth * 0.15; // Kích thước nút dựa trên chiều rộng màn hình

    return Scaffold(
      // backgroundColor: Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                widthFactor: screenWidth,
                heightFactor: screenHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // if (_capturedImage == null)
                    FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(_cameraController!);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    // else
                    //   // Hiển thị ảnh vừa chụp
                    //   Image.file(
                    //     File(_capturedImage!.path),
                    //     fit: BoxFit.cover,
                    //     width: double.infinity,
                    //     height: double.infinity,
                    //   ),

                    // Hiệu ứng nháy màn hình
                    if (_isFlashing)
                      Container(
                        color: Colors.white.withOpacity(0.7),
                        width: double.infinity,
                        height: double.infinity,
                      ),

                    // Nút chức năng
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: _takePicture,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.camera_alt,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    )
                    // if (_capturedImage == null)
                    //   Positioned(
                    //     bottom: 30,
                    //     left: 0,
                    //     right: 0,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         FloatingActionButton(
                    //           onPressed: _takePicture,
                    //           backgroundColor: Colors.white,
                    //           child: const Icon(Icons.camera_alt,
                    //               color: Colors.black),
                    //         ),
                    //       ],
                    //     ),
                    //   )
                    // else
                    // Positioned(
                    //   bottom: 30,
                    //   left: 0,
                    //   right: 0,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       // Nút hủy
                    //       IconButton(
                    //         icon: const Icon(Icons.close_outlined,
                    //             size: 50, color: Colors.red),
                    //         onPressed: _cancelImage,
                    //       ),
                    //       // Nút lưu
                    //       IconButton(
                    //         icon: const Icon(Icons.check_sharp,
                    //             size: 50, color: Colors.green),
                    //         onPressed: _saveImage,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              height: 150,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  // Kiểm tra xem có ảnh trong danh sách hay không
                  bool hasImage = capturedImages.length > index;
                  print('Ảnh được lưu: ${capturedImages[index]}');
                  return GestureDetector(
                    onTap: hasImage // Chỉ cho phép nhấn nếu có ảnh
                        ? () {
                            if (capturedImages[index] != null) {
                              _showImageDialog(capturedImages[index]!, index);
                            }
                          }
                        : null,
                    child: AbsorbPointer(
                      absorbing: !hasImage, // Vô hiệu hóa khi không có ảnh
                      child: Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: capturedImages[index] != null // Kiểm tra trước
                            ? Stack(
                                children: [
                                  hasImage
                                      ? Image.file(
                                          width: 70,
                                          height: 70,
                                          File(capturedImages[index]!),
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.photo,
                                          color: Colors.grey,
                                        ),
                                        
                                  if (hasImage)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            capturedImages[index] = null;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : const Icon(
                                Icons.photo,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (_canSave())
              RoundButton(
                onPressed: _saveAllImages,
                title: "Save All Images",
              ),
          ],
        ),
      ),
    );
  }
}

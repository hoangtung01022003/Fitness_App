import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingHelper {
  static OverlayEntry? _overlayEntry;

  // Hàm hiển thị loading
  static void showLoadingOverlay(BuildContext context) {
    if (_overlayEntry != null) return; // Kiểm tra nếu đã có overlay thì không tạo mới

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Layer mờ để phủ lên màn hình
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          // Widget loading animation
          Center(
            child: LoadingAnimationWidget.twoRotatingArc(
              color: Colors.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );

    // Thêm overlay vào Overlay của context
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Hàm ẩn loading
  static void hideLoadingOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

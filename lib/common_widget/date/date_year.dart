import 'package:fitness/common/assets.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/date/date_picker_helper.dart';
import 'package:flutter/material.dart';

class Date_year extends StatelessWidget {
  const Date_year({
    super.key,
    required this.txtDate,
    required this.selectedDate, 
    required this.hintText,
  });

  final TextEditingController txtDate;
  final DateTime selectedDate;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller:
            txtDate, // Đảm bảo rằng bạn đã khai báo controller
        keyboardType: TextInputType
            .text, // Bạn có thể thay đổi loại bàn phím nếu cần
        obscureText: false, // Nếu không cần ẩn văn bản
        readOnly:
            true, // Đặt readOnly để chỉ cho phép chọn ngày từ dialog
        onTap: () {
          selectDate(context, selectedDate, txtDate);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText, // Thông điệp gợi ý
          hintStyle:
              TextStyle(color: TColor.gray, fontSize: 12),
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 50, // Thay đổi kích thước nếu cần
            height: 50,
            padding:
                const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              TImages.date, // Biểu tượng hình ảnh
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: TColor.gray,
            ),
          ),
        ),
      ),
    );
  }
}

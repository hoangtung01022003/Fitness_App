// date_picker_helper.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện intl để định dạng ngày

void selectDate(BuildContext context, DateTime selectedDate,
    TextEditingController txtDate) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: 200,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDate,
          onDateTimeChanged: (DateTime newDateTime) {
            // Định dạng ngày thành yyyy-MM-dd
            final formattedDate = DateFormat('yyyy-MM-dd').format(newDateTime);
            txtDate.text = formattedDate;
          },
        ),
      );
    },
  );
}

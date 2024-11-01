int calculateAge(String dateOfBirth) {
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();

      // Tính tuổi
      int age = now.year - birthDate.year;

      // Điều chỉnh nếu ngày sinh chưa đến trong năm hiện tại
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print('Lỗi khi tính tuổi: $e');
      return 0; // Hoặc có thể trả về giá trị mặc định khác
    }
  }
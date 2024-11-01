class AuthValidator {
  static String? validateFirstName(String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return 'Vui lòng nhập tên.';
    }
    return null; // Nếu hợp lệ, trả về null
  }

  static String? validateLastName(String? lastName) {
    if (lastName == null || lastName.isEmpty) {
      return 'Vui lòng nhập họ.';
    }
    return null; // Nếu hợp lệ, trả về null
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Vui lòng nhập email.';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      return 'Email không hợp lệ.';
    }
    return null; // Nếu hợp lệ, trả về null
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    } else if (password.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    return null; // Nếu hợp lệ, trả về null
  }
}

class ProfileValidator {
  // Phương thức xác thực cho gender
  static String? validateGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return 'Vui lòng chọn giới tính.';
    }
    return null;
  }

  // Phương thức xác thực cho dateOfBirth
  static String? validateDateOfBirth(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return 'Vui lòng nhập ngày sinh.';
    }
    if (dateOfBirth.isAfter(DateTime.now())) {
      return 'Ngày sinh không thể là ngày trong tương lai.';
    }
    return null;
  }

  // Phương thức xác thực cho height
  static String? validateHeight(double? height) {
    if (height == null || height <= 0) {
      return 'Chiều cao không hợp lệ. Vui lòng nhập chiều cao dương.';
    }
    return null;
  }

  // Phương thức xác thực cho weight
  static String? validateWeight(double? weight) {
    if (weight == null || weight <= 0) {
      return 'Cân nặng không hợp lệ. Vui lòng nhập cân nặng dương.';
    }
    return null;
  }
}

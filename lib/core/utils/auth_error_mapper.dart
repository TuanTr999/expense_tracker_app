class AuthErrorMapper {
  static String map(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email không hợp lệ';

      case 'user-disabled':
        return 'Tài khoản này đã bị vô hiệu hóa';

      case 'user-not-found':
        return 'Email chưa được đăng ký';

      case 'wrong-password':
        return 'Mật khẩu không chính xác';

      case 'invalid-credential':
        return 'Email hoặc mật khẩu không chính xác';

      case 'email-already-in-use':
        return 'Email này đã được sử dụng';

      case 'weak-password':
        return 'Mật khẩu phải có ít nhất 6 ký tự';

      case 'operation-not-allowed':
        return 'Phương thức đăng nhập này chưa được bật';

      case 'too-many-requests':
        return 'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau';

      case 'network-request-failed':
        return 'Không có kết nối mạng';

      case 'missing-email':
        return 'Vui lòng nhập email';

      case 'missing-password':
        return 'Vui lòng nhập mật khẩu';

      case 'internal-error':
        return 'Hệ thống đang gặp sự cố. Vui lòng thử lại sau';

      case 'expired-action-code':
        return 'Liên kết đặt lại mật khẩu đã hết hạn';

      case 'invalid-action-code':
        return 'Liên kết đặt lại mật khẩu không hợp lệ';

      case 'account-exists-with-different-credential':
        return 'Email này đã được đăng ký bằng phương thức đăng nhập khác';

      default:
        return 'Đã có lỗi xảy ra. Vui lòng thử lại';
    }
  }
}
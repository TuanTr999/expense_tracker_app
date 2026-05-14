import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final Dio dio;

  GeminiService(this.dio);

  Future<String> sendMessage(String message) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null) return "Lỗi: Chưa cấu hình API Key.";

    final prompt =
        """
Bạn là trợ lý tài chính cá nhân trong ứng dụng quản lý thu chi.
Nhiệm vụ:
- Trả lời bằng tiếng Việt, ngắn gọn, dễ hiểu.
- Đưa lời khuyên tài chính cá nhân đơn giản.
- Ưu tiên: chi tiêu, tiết kiệm, ngân sách, quản lý tài chính.

Câu hỏi người dùng:
$message
""";

    try {
      final response = await dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$apiKey',
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 1,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 2048,
          }
        },
      );

      // Kiểm tra cấu trúc phản hồi trước khi truy cập
      if (response.data != null &&
          response.data['candidates'] != null &&
          response.data['candidates'].isNotEmpty) {
        return response.data['candidates'][0]['content']['parts'][0]['text'] ??
            "Mình chưa nghĩ ra câu trả lời.";
      }

      return "Không có phản hồi từ trợ lý.";
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error']?['message'] ?? e.message;

      if (errorMessage.toString().contains('Quota exceeded')) {
        return 'Bạn đã vượt giới hạn Gemini API miễn phí. Vui lòng thử lại sau ít phút.';
      }

      return 'Lỗi kết nối: $errorMessage';
    }
  }
}

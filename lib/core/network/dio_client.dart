import 'dart:io';
import 'package:dio/dio.dart';

import '../config/api_config.dart';


class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ REQUEST: ${options.method} ${options.uri}");
          print("➡️ HEADERS: ${options.headers}");
          // print("➡️ DATA: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ RESPONSE: ${response.statusCode}");
          // print("✅ DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print("❌ ERROR: ${e.message}");

          if (e.type == DioExceptionType.connectionTimeout) {
            print("⏰ Timeout kết nối server");
          } else if (e.type == DioExceptionType.receiveTimeout) {
            print("⏰ Timeout nhận dữ liệu");
          } else if (e.type == DioExceptionType.badResponse) {
            print("🚨 Server trả lỗi: ${e.response?.statusCode}");
          } else if (e.type == DioExceptionType.connectionError) {
            print("🚫 Không kết nối được server");
          }

          print("❌ DATA: ${e.response?.data}");

          return handler.next(e);
        },
      ),
    );
  }
}
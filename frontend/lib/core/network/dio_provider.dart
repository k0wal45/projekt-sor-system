import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_interceptor.dart';

part 'dio_provider.g.dart';

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@riverpod
Dio dio(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(AuthInterceptor(secureStorage));
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
}

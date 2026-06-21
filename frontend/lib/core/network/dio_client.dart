import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../constants/env_constants.dart';
import 'secure_storage_service.dart';

part 'dio_client.g.dart';

@Riverpod(keepAlive: true)
Dio dioClient(Ref ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConstants.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
}

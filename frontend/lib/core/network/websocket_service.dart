import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../features/admissions/domain/admission_entity.dart';
import '../constants/env_constants.dart';
import 'secure_storage_service.dart';

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final service = WebSocketService(storage);

  ref.onDispose(() {
    service.disconnect();
  });

  return service;
});

class WebSocketService {
  final SecureStorageService _storage;
  WebSocketChannel? _channel;
  final _admissionsController =
      StreamController<List<AdmissionEntity>>.broadcast();

  WebSocketService(this._storage);

  Stream<List<AdmissionEntity>> get queueStream => _admissionsController.stream;

  Future<void> connect() async {
    final token = await _storage.getToken();

    // Allow empty token for public board (TV)
    final tokenQuery = token != null ? '?token=$token' : '';

    final uri = Uri.parse(EnvConstants.apiUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
    final wsUrlStr =
        '$wsScheme://${uri.host}:${uri.port}${path}ws/admissions/queue$tokenQuery';

    _channel = WebSocketChannel.connect(Uri.parse(wsUrlStr));

    _channel!.stream.listen(
      (message) {
        try {
          final List<dynamic> decoded = jsonDecode(message);
          final admissions = decoded
              .map((e) => AdmissionEntity.fromJson(e))
              .toList();
          _admissionsController.add(admissions);
        } catch (e, st) {
          _admissionsController.addError('Błąd parsowania ws: $e', st);
        }
      },
      onDone: () {
        // print('Rozłączono WS');
      },
      onError: (error, st) {
        _admissionsController.addError('Błąd połączenia ws: $error', st);
      },
    );
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}

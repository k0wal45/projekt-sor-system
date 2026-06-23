import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../features/admissions/domain/admission_entity.dart';
import '../constants/env_constants.dart';
import 'secure_storage_service.dart';

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final service = WebSocketService(storage);

  service.connect();

  ref.onDispose(() {
    service.disconnect();
  });

  return service;
});

class WebSocketService {
  final SecureStorageService _storage;
  WebSocketChannel? _channel;
  StreamController<List<AdmissionEntity>>? _admissionsController;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;

  static const int _maxReconnectAttempts = 10;
  static const Duration _initialReconnectDelay = Duration(seconds: 2);

  WebSocketService(this._storage) {
    _admissionsController = StreamController<List<AdmissionEntity>>.broadcast();
  }

  Stream<List<AdmissionEntity>> get queueStream =>
      _admissionsController?.stream ?? const Stream.empty();

  bool get isConnected => _channel != null;

  Future<void> connect() async {
    if (_isDisposed) return;
    if (_channel != null) return;

    final token = await _storage.getToken();

    final tokenQuery = token != null ? '?token=$token' : '';

    final uri = Uri.parse(EnvConstants.apiUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
    final wsUrlStr =
        '$wsScheme://${uri.host}:${uri.port}${path}ws/admissions/queue$tokenQuery';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrlStr));

      _channel!.stream.listen(
        (message) {
          _reconnectAttempts = 0;
          try {
            final List<dynamic> decoded = jsonDecode(message);
            final admissions =
                decoded.map((e) => AdmissionEntity.fromJson(e)).toList();
            _admissionsController?.add(admissions);
          } catch (e, st) {
            _admissionsController?.addError('Błąd parsowania ws: $e', st);
          }
        },
        onDone: () {
          _channel = null;
          _scheduleReconnect();
        },
        onError: (error, st) {
          _admissionsController?.addError('Błąd połączenia ws: $error', st);
          _channel = null;
          _scheduleReconnect();
        },
      );
    } catch (e) {
      _channel = null;
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) return;

    _reconnectTimer?.cancel();
    final delay = _initialReconnectDelay * pow(2, _reconnectAttempts);
    _reconnectAttempts++;

    _reconnectTimer = Timer(delay, () {
      connect();
    });
  }

  void disconnect() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channel?.sink.close();
    _channel = null;
    _admissionsController?.close();
    _admissionsController = null;
  }
}

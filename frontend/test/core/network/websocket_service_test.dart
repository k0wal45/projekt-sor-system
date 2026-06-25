import 'dart:async';
import 'package:esor/core/network/secure_storage_service.dart';
import 'package:esor/core/network/websocket_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockWebSocketChannel extends Mock implements WebSocketChannel {}

class MockWebSocketSink extends Mock implements WebSocketSink {}

void main() {
  late MockSecureStorageService mockStorage;
  late StreamController<dynamic> channelController;
  late MockWebSocketChannel mockChannel;
  late MockWebSocketSink mockSink;
  late WebSocketService webSocketService;

  setUp(() {
    mockStorage = MockSecureStorageService();
    channelController = StreamController<dynamic>.broadcast();
    mockChannel = MockWebSocketChannel();
    mockSink = MockWebSocketSink();
    
    when(() => mockChannel.stream).thenAnswer((_) => channelController.stream);
    when(() => mockChannel.sink).thenReturn(mockSink);
    when(() => mockSink.close()).thenAnswer((_) async {});
    
    webSocketService = WebSocketService(
      mockStorage,
      channelFactory: (uri) => mockChannel,
    );
  });

  tearDown(() {
    webSocketService.disconnect();
    channelController.close();
  });

  group('WebSocketService', () {
    test('initial state is disconnected', () {
      expect(webSocketService.isConnected, isFalse);
    });

    test('connect establishes connection and sets up listener', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'fake-token');
      
      await webSocketService.connect();
      
      expect(webSocketService.isConnected, isTrue);
    });

    test('disconnect closes the stream and cleans up', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'fake-token');
      
      await webSocketService.connect();
      expect(webSocketService.isConnected, isTrue);

      webSocketService.disconnect();
      
      expect(webSocketService.isConnected, isFalse);
    });

    test('parses valid json message into queueStream', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'fake-token');
      
      await webSocketService.connect();

      final validJson = '''
      [
        {
          "id": 1,
          "id_pacjenta": 1,
          "id_osoby_przyjmujacej": 1,
          "data_przyjecia": "2023-10-10T10:00:00Z",
          "forma_przybycia": "Karetka publiczna",
          "injury": false,
          "mental_status": "W pełni świadomy",
          "pain": false,
          "pain_lvl": 0,
          "hr": 70,
          "sbp": 120,
          "dbp": 80,
          "rr": 16,
          "bt": 36.6,
          "chief_complaint": "Ból ręki",
          "priority_ktas": 3,
          "is_ai_predicted": false,
          "status_przyjecia": "W_POCZEKALNI"
        }
      ]
      ''';

      final streamFuture = webSocketService.queueStream.first;
      
      channelController.add(validJson);
      
      final admissions = await streamFuture;
      expect(admissions.length, 1);
      expect(admissions.first.id, 1);
      expect(admissions.first.chiefComplaint, 'Ból ręki');
    });

    test('adds error to stream on invalid json', () async {
      when(() => mockStorage.getToken()).thenAnswer((_) async => 'fake-token');
      
      await webSocketService.connect();

      final invalidJson = '{ "broken": "json" ';

      final streamFuture = webSocketService.queueStream.first;
      
      channelController.add(invalidJson);
      
      expect(() async => await streamFuture, throwsA(isA<String>()));
    });
  });
}


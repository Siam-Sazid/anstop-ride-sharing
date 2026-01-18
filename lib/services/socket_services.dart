import 'dart:async';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../services/api_urls.dart';

class SocketIoService extends GetxService {
  final Logger _logger = Logger();
  IO.Socket? _socket;
  final RxBool isConnected = false.obs;

  static SocketIoService get to => Get.find<SocketIoService>();

  Future<SocketIoService> init() async {
    return this;
  }

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      _logger.i('Socket already connected');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    if (token.isEmpty) {
      _logger.e('No access token found for socket connection');
      return;
    }

    _logger.i('Creating socket connection to ${ApiUrls.socketUrl}');

    final completer = Completer<void>();

    _socket = IO.io(ApiUrls.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'auth': {'token': token},
    });

    _socket!.onConnect((_) {
      _logger.i('Socket connected successfully!');
      isConnected.value = true;
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _socket!.onDisconnect((_) {
      _logger.w('Socket disconnected');
      isConnected.value = false;
    });

    _socket!.onConnectError((data) {
      _logger.e('Socket connection error: $data');
      isConnected.value = false;
      if (!completer.isCompleted) {
        completer.complete();
      }
      _retryConnection();
    });

    _socket!.onError((data) {
      _logger.e('Socket error: $data');
    });

    _socket!.onAny((event, data) {
      _logger.i('Socket event received: $event, data: $data');
    });

    // Wait for connection with timeout
    try {
      await completer.future.timeout(const Duration(seconds: 10));
      _logger.i('Socket connection completed, isConnected: ${isConnected.value}');
    } catch (e) {
      _logger.e('Socket connection timeout: $e');
    }
  }

  void _retryConnection() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_socket != null && !_socket!.connected) {
        _logger.i('Retrying socket connection...');
        _socket!.connect();
      }
    });
  }

  void disconnect() {
    _socket?.disconnect();
    isConnected.value = false;
  }

  void on(String event, Function(dynamic) handler) {
    if (_socket == null) {
      _logger.e('Cannot register listener for $event - socket is null!');
      return;
    }
    _logger.i('Registering listener for event: $event, socket connected: ${_socket!.connected}');
    _socket!.on(event, handler);
  }

  void emit(String event, [dynamic data]) {
    if (_socket == null) {
      _logger.e('Cannot emit $event - socket is null!');
      return;
    }
    _socket!.emit(event, data);
  }

  void off(String event) {
    _logger.i('Removing listener for event: $event');
    _socket?.off(event);
  }

  // Listen for nearest drivers
  void onNearestDrivers(Function(dynamic) handler) {
    if (_socket == null) {
      _logger.e('Cannot register nearest-drivers listener - socket is null!');
      return;
    }
    _logger.i('Registering nearest-drivers listener, socket connected: ${_socket!.connected}');
    _socket!.on('nearest-drivers', (data) {
      _logger.i('nearest-drivers event received in service: $data');
      handler(data);
    });
  }

  // Stop listening for nearest drivers
  void offNearestDrivers() {
    _logger.i('Removing nearest-drivers listener');
    _socket?.off('nearest-drivers');
  }

  // Listen for ride request (for drivers)
  void onRideRequest(Function(dynamic) handler) {
    if (_socket == null) {
      _logger.e('Cannot register ride-request listener - socket is null!');
      return;
    }
    _logger.i('Registering ride-request listener, socket connected: ${_socket!.connected}');
    _socket!.on('ride-request', (data) {
      _logger.i('ride-request event received in service: $data');
      handler(data);
    });
  }

  // Stop listening for ride request
  void offRideRequest() {
    _logger.i('Removing ride-request listener');
    _socket?.off('ride-request');
  }

  // Check if socket is ready
  bool get isSocketReady => _socket != null && _socket!.connected;

  // Send a new message
  void sendMessage({
    required String conversationId,
    String? text,
    String? attachments,
  }) {
    if (text == null && attachments == null) {
      _logger.e('At least one of text or attachments is required');
      return;
    }

    final payload = <String, dynamic>{
      'conversationId': conversationId,
    };

    if (text != null && text.isNotEmpty) {
      payload['text'] = text;
    }

    if (attachments != null && attachments.isNotEmpty) {
      payload['attachments'] = attachments;
    }

    _logger.i('Sending message: $payload');
    emit('send-new-message', payload);
  }

  // Listen for new messages
  void onNewMessage(Function(dynamic) handler) {
    on('new-message', handler);
  }

  // Stop listening for new messages
  void offNewMessage() {
    off('new-message');
  }
}


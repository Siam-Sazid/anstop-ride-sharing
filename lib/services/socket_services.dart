import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../app/helpers/prefs_helper.dart';
import '../app/utils/app_constants.dart';

class SocketServices {
  // Singleton instance
  static final SocketServices _socketApi = SocketServices._internal();
  static String? token;

  IO.Socket? socket;
  bool _isManualDisconnect = false; // <-- added flag

  factory SocketServices() {
    return _socketApi;
  }

  SocketServices._internal();

  /// Initialize socket connection
  Future<void> init() async {
    if (socket != null) {
      if (socket!.connected) {
        debugPrint("⚠️ Socket already connected, skipping init");
        return;
      } /*else {
        print("⚠️ Socket instance exists but not connected, reconnecting...");
        socket!.connect();
        return;
      }*/
    }

    _isManualDisconnect = false;
    token = await PrefsHelper.getString(AppConstants.bearerToken) ?? "";

    debugPrint("-------------------------------------------------------------\n🔌 Socket init called \n🪪 token = $token");

    socket = IO.io(
      ApiUrls.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({"authorization": "Bearer $token"})
          .enableReconnection()
          .build(),
    );

    _setupSocketListeners(token.toString());
    //socket!.connect();
  }

  /// Setup listeners for socket events
  void _setupSocketListeners(String token) {
    socket?.clearListeners(); // <-- important: clear old listeners

    socket?.onConnect((_) {
      debugPrint('✅ Socket connected: ${socket?.connected}');
    });

    socket?.onConnectError((err) {
      debugPrint('❌ Socket connect error: $err');
    });

    socket?.onDisconnect((_) {
      debugPrint('⚠️ Socket disconnected');
      if (!_isManualDisconnect) {
        debugPrint('🔄 Attempting to reconnect...');
        Future.delayed(const Duration(seconds: 2), () {
          if (socket != null && !socket!.connected) {
            socket!.connect();
          }
        });
      } else {
        debugPrint('🛑 Manual disconnect: no auto-reconnect');
      }
    });

    socket?.onReconnect((_) {
      debugPrint('🔄 Socket reconnected! token: $token');
    });

    socket?.onError((error) {
      debugPrint('🚫 Socket error: $error');
    });
  }

  /// Emit with acknowledgment
  Future<dynamic> emitWithAck(String event, dynamic body) async {
    final completer = Completer<dynamic>();

    if (socket == null || !socket!.connected) {
      debugPrint("⚠️ emitWithAck failed: socket not connected or initialized");
      completer.completeError("Socket not initialized or connected");
      return completer.future;
    }

    socket!.emitWithAck(event, body, ack: (data) {
      debugPrint("📨 Ack received for $event: $data");
      completer.complete(data ?? 1);
    });

    return completer.future;
  }

  /// Emit without acknowledgment
  void emit(String event, dynamic body) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, body);
      debugPrint('📤 Emit: $event\n➡️ Data: $body');
    } else {
      debugPrint("⚠️ Emit failed: socket not connected");
    }
  }

  /// Disconnect socket
  void disconnect() {
    _isManualDisconnect = true; // <-- mark as manual
    socket?.disconnect();
    debugPrint('🔌 Socket manually disconnected');
  }
}

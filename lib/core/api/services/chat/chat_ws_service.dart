import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWsService extends GetxService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  int _reconnectAttempt = 0;
  bool _isManuallyClosed = false;

  // 🎯 Stream សម្រាប់បោះ Data ទៅកាន់ ChatRoomController និង ChatListController
  final _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  void connect(String token) {
    _isManuallyClosed = false;
    final wsUrl = Uri.parse(
      'wss://jobber-city-api-staging.up.railway.app/api/chat/ws?token=$token',
    );

    try {
      _channel = WebSocketChannel.connect(wsUrl);
      _reconnectAttempt = 0; // Reset ពេលភ្ជាប់ជោគជ័យ
      debugPrint("✅ WebSocket Connected");

      _channel!.stream.listen(
        (message) {
          final data = jsonDecode(message);
          _messageStreamController.add(
            data,
          ); // 🎯 បោះទិន្នន័យឱ្យ Controller ស្តាប់
        },
        onDone: () => _handleDisconnect(),
        onError: (error) {
          debugPrint("❌ WebSocket Error: $error");
          _handleDisconnect();
        },
      );
    } catch (e) {
      _handleDisconnect();
    }
  }

  void sendEvent(String type, Map<String, dynamic> data) {
    if (_channel != null) {
      data['type'] = type;
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void _handleDisconnect() {
    if (_isManuallyClosed) return;

    // 🎯 Exponential Backoff: រង់ចាំយូរជាងមុនបន្តិចម្តងៗ ពេលភ្ជាប់មិនបាន (1s, 2s, 4s, 8s...)
    int delay = (1 << _reconnectAttempt).clamp(1, 30);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delay), () {
      debugPrint(
        "🔄 Attempting to reconnect... (Attempt ${_reconnectAttempt + 1})",
      );
      _reconnectAttempt++;
      // connect("យក_Token_ពី_Storage_មកវិញ");
    });
  }

  void disconnect() {
    _isManuallyClosed = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    debugPrint("🛑 WebSocket Disconnected Manually");
  }

  @override
  void onClose() {
    _messageStreamController.close();
    disconnect();
    super.onClose();
  }
}

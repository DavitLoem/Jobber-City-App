import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:jobber_city/core/api/config/api_config.dart';
import 'package:jobber_city/core/utils/token_storage.dart';

enum ChatSocketStatus { disconnected, connecting, connected, reconnecting }

/// Single shared WebSocket connection to `/api/chat/ws` for the whole app
/// session (one socket, not one per screen) — both the Chat List (inbox)
/// and any open Chat Thread listen to the same [events] stream, matching
/// how the backend fans a single `new_message`/`typing`/`read_receipt`
/// payload out to every device the user has connected (see
/// `connection_manager.py`).
///
/// Registered as a permanent GetX singleton the first time any chat screen
/// needs it (`ChatSocketService.instance`) — see `chat_list_binding.dart` /
/// `chat_thread_binding.dart`.
class ChatSocketService extends GetxService {
  static ChatSocketService get instance {
    if (Get.isRegistered<ChatSocketService>()) return Get.find<ChatSocketService>();
    return Get.put(ChatSocketService(), permanent: true);
  }

  WebSocketChannel? _channel;
  StreamSubscription? _channelSub;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _manuallyDisconnected = false;

  final _eventsController = StreamController<Map<String, dynamic>>.broadcast();

  /// Every decoded JSON payload the server sends: `new_message`, `typing`,
  /// `read_receipt`, `pong`, `error`. Screens filter by `conversation_id`
  /// or `type` as needed.
  Stream<Map<String, dynamic>> get events => _eventsController.stream;

  final status = ChatSocketStatus.disconnected.obs;

  bool get isConnected => status.value == ChatSocketStatus.connected;

  Future<void> connect() async {
    if (status.value == ChatSocketStatus.connected || status.value == ChatSocketStatus.connecting) {
      return;
    }

    final token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      debugPrint('[ChatSocket] No access token — cannot connect.');
      return;
    }

    _manuallyDisconnected = false;
    status.value = ChatSocketStatus.connecting;

    try {
      final uri = Uri.parse('${ApiConfig.wsBaseUrl}/chat/ws?token=$token');
      final channel = WebSocketChannel.connect(uri);
      await channel.ready; // throws if the handshake itself fails (wrong host/port/closed server)

      _channel = channel;
      status.value = ChatSocketStatus.connected;
      _reconnectAttempts = 0;
      debugPrint('[ChatSocket] Connected.');

      _channelSub = channel.stream.listen(
        _onData,
        onDone: _onDisconnected,
        onError: (e) {
          debugPrint('[ChatSocket] Stream error: $e');
          _onDisconnected();
        },
        cancelOnError: true,
      );

      _startHeartbeat();
    } catch (e) {
      debugPrint('[ChatSocket] Connect failed: $e');
      status.value = ChatSocketStatus.disconnected;
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    try {
      final decoded = jsonDecode(raw as String) as Map<String, dynamic>;
      if (decoded['type'] == 'pong') return; // heartbeat ack, nothing to broadcast
      _eventsController.add(decoded);
    } catch (e) {
      debugPrint('[ChatSocket] Failed to decode message: $e');
    }
  }

  void _onDisconnected() {
    _heartbeatTimer?.cancel();
    _channelSub = null;
    _channel = null;

    if (_manuallyDisconnected) {
      status.value = ChatSocketStatus.disconnected;
      return;
    }

    status.value = ChatSocketStatus.reconnecting;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_manuallyDisconnected) return;
    _reconnectTimer?.cancel();

    // Exponential backoff capped at 30s so a dead server doesn't spin the
    // client into a tight retry loop, but reconnects quickly on a blip.
    _reconnectAttempts++;
    final delaySeconds = (2 * _reconnectAttempts).clamp(2, 30);
    debugPrint('[ChatSocket] Reconnecting in ${delaySeconds}s (attempt $_reconnectAttempts)...');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), connect);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    // Server-side comment says the client should ping roughly every ~25s to
    // stop proxies/load balancers from killing an "idle" connection.
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      _send({'type': 'ping'});
    });
  }

  void _send(Map<String, dynamic> payload) {
    if (_channel == null || status.value != ChatSocketStatus.connected) {
      debugPrint('[ChatSocket] Dropped send — not connected: $payload');
      return;
    }
    _channel!.sink.add(jsonEncode(payload));
  }

  void sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    String? attachmentUrl,
    required String clientTempId,
  }) {
    _send({
      'type': 'send_message',
      'conversation_id': conversationId,
      'content': content,
      'message_type': messageType,
      if (attachmentUrl != null) 'attachment_url': attachmentUrl,
      'client_temp_id': clientTempId,
    });
  }

  void sendTyping({required String conversationId, required bool isTyping}) {
    _send({
      'type': 'typing',
      'conversation_id': conversationId,
      'is_typing': isTyping,
    });
  }

  void sendRead({required String conversationId}) {
    _send({'type': 'read', 'conversation_id': conversationId});
  }

  /// Only call this on logout — the socket is meant to stay alive for the
  /// whole session across chat screens.
  void disconnectManually() {
    _manuallyDisconnected = true;
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _channelSub?.cancel();
    _channel?.sink.close();
    _channel = null;
    status.value = ChatSocketStatus.disconnected;
  }

  @override
  void onClose() {
    disconnectManually();
    _eventsController.close();
    super.onClose();
  }
}

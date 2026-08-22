part of 'chat_room_view.dart';

class ChatRoomViewController extends GetxController {
  final ChatRestService _restService = Get.find<ChatRestService>();
  final ChatWsService _wsService = Get.find<ChatWsService>();
  final _uuid = const Uuid();

  late ChatThreadArgs args;
  String? currentUserId;

  final conversationId = RxnString();
  final isSettingUp = true.obs;
  final setupError = ''.obs;

  final messages = <ChatMessage>[].obs;
  final isLoadingHistory = false.obs;
  final isLoadingMore = false.obs;
  final hasMoreHistory = true.obs;

  final isOtherPartyTyping = false.obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  StreamSubscription? _wsSubscription;
  Timer? _typingStopTimer;
  Timer? _otherTypingClearTimer;
  bool _isTypingSent = false;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is ChatThreadArgs) {
      args = Get.arguments as ChatThreadArgs;
    } else {
      setupError.value = "Invalid Arguments";
      return;
    }

    scrollController.addListener(_onScroll);
    _setup();
  }

  Future<void> _setup() async {
    isSettingUp.value = true;
    setupError.value = '';

    currentUserId = await TokenStorage.getUserId();
    _wsSubscription = _wsService.messageStream.listen(_onSocketEvent);

    try {
      if (args.conversationId != null) {
        conversationId.value = args.conversationId;
      } else if (args.otherUserId != null) {
        final convo = await _restService.startConversation(
          otherUserId: args.otherUserId!,
          jobId: args.jobId,
        );
        conversationId.value = convo.id;
      } else {
        throw Exception("Missing both conversationId and otherUserId");
      }

      await _loadInitialMessages();
      _markRead();
    } catch (e) {
      setupError.value = 'Could not open conversation.';
      debugPrint('[ChatRoom] setup error: $e');
    } finally {
      isSettingUp.value = false;
    }
  }

  Future<void> _loadInitialMessages() async {
    if (conversationId.value == null) return;
    isLoadingHistory.value = true;
    try {
      final result = await _restService.getMessages(conversationId.value!);
      messages.assignAll(result.messages);
      hasMoreHistory.value = result.hasMore;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToBottom(animated: false),
      );
    } catch (e) {
      debugPrint('[ChatRoom] load history error: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> loadMoreHistory() async {
    if (!hasMoreHistory.value ||
        isLoadingMore.value ||
        conversationId.value == null ||
        messages.isEmpty)
      return;
    isLoadingMore.value = true;
    try {
      final oldestId = messages.last.id;
      final result = await _restService.getMessages(
        conversationId.value!,
        before: oldestId,
      );
      messages.addAll(result.messages);
      hasMoreHistory.value = result.hasMore;
    } catch (e) {
      debugPrint('[ChatRoom] load more error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreHistory();
    }
  }

  void _markRead() {
    final id = conversationId.value;
    if (id != null) _restService.markAsRead(id);
  }

  void _onSocketEvent(Map<String, dynamic> event) {
    final type = event['type'];
    final data = event['data'] as Map<String, dynamic>? ?? event;

    if (type == 'new_message') {
      if (data['conversation_id']?.toString() != conversationId.value) return;

      final incoming = ChatMessage.fromJson(data);

      final pendingIndex = incoming.clientTempId != null
          ? messages.indexWhere(
              (m) => m.clientTempId == incoming.clientTempId && m.isPending,
            )
          : -1;

      if (pendingIndex != -1) {
        messages[pendingIndex] = incoming;
      } else if (!messages.any((m) => m.id == incoming.id)) {
        messages.insert(0, incoming);
      }

      messages.refresh();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      if (incoming.senderId != currentUserId) {
        _markRead();
      }
      return;
    }

    if (type == 'typing') {
      if (data['conversation_id']?.toString() != conversationId.value) return;
      if (data['user_id']?.toString() == currentUserId) return;

      isOtherPartyTyping.value = data['is_typing'] == true;
      _otherTypingClearTimer?.cancel();
      if (isOtherPartyTyping.value) {
        _otherTypingClearTimer = Timer(
          const Duration(seconds: 6),
          () => isOtherPartyTyping.value = false,
        );
      }
      return;
    }

    if (type == 'read_receipt') {
      if (data['conversation_id']?.toString() != conversationId.value) return;

      for (var i = 0; i < messages.length; i++) {
        final m = messages[i];
        if (m.senderId == currentUserId && m.status != 'read') {
          messages[i] = m.copyWith(status: 'read');
        }
      }
      messages.refresh();
      return;
    }

    if (type == 'message_deleted') {
      if (data['conversation_id']?.toString() != conversationId.value) return;

      final msgId = data['message_id']?.toString();
      final deleteType = data['delete_type']?.toString();

      if (msgId != null) {
        if (deleteType == 'everyone') {
          final index = messages.indexWhere((m) => m.id == msgId);
          if (index != -1) {
            // Update ទៅជាទម្រង់ Tombstone ភ្លាមៗ
            messages[index] = messages[index].copyWith(
              isDeletedForEveryone: true,
              content: "",
            );
            messages.refresh();
          }
        } else if (deleteType == 'me') {
          // លុបចេញពី UI យើងបាត់ឈឹងតែម្តង
          messages.removeWhere((m) => m.id == msgId);
          messages.refresh();
        }
      }
      return;
    }
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    final id = conversationId.value;
    if (text.isEmpty || id == null) return;

    final clientTempId = _uuid.v4();
    textController.clear();
    _stopTyping();

    final optimistic = ChatMessage(
      id: 'pending-$clientTempId',
      conversationId: id,
      senderId: currentUserId ?? '',
      senderRole: '',
      messageType: 'text',
      content: text,
      status: 'sending',
      clientTempId: clientTempId,
      createdAt: DateTime.now(),
      isPending: true,
    );
    messages.insert(0, optimistic);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      _wsService.sendEvent('send_message', {
        "conversation_id": id,
        "content": text,
        "message_type": "text",
        "client_temp_id": clientTempId,
      });
    } catch (e) {
      try {
        final sent = await _restService.sendMessageRest(
          conversationId: id,
          content: text,
          clientTempId: clientTempId,
        );
        final idx = messages.indexWhere((m) => m.clientTempId == clientTempId);
        if (idx != -1) {
          messages[idx] = sent;
          messages.refresh();
        }
      } catch (eREST) {
        final idx = messages.indexWhere((m) => m.clientTempId == clientTempId);
        if (idx != -1) {
          messages[idx] = messages[idx].copyWith(
            status: 'failed',
            isPending: false,
          );
          messages.refresh();
        }
      }
    }
  }

  void showDeleteOptions(ChatMessage message) {
    if (message.isDeletedForEveryone || message.isPending) {
      return; // មិនអាចលុបសារដែលលុបរួច ឫកំពុងផ្ញើ
    }

    final isMine = message.senderId == currentUserId;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Message Options",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ជម្រើសទី ១: Delete for Me (មានសម្រាប់ទាំងសារយើង និងសារគេ)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.black87),
              title: const Text("Delete for me"),
              onTap: () {
                Get.back();
                _confirmAndDelete(message, 'me');
              },
            ),

            // ជម្រើសទី ២: Delete for Everyone (មានតែសម្រាប់សារដែលយើងផ្ញើប៉ុណ្ណោះ)
            if (isMine)
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  "Delete for everyone",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Get.back();
                  _confirmAndDelete(message, 'everyone');
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmAndDelete(ChatMessage message, String type) async {
    final title = type == 'everyone'
        ? 'Delete for Everyone?'
        : 'Delete for Me?';
    final content = type == 'everyone'
        ? 'This message will be deleted for all participants in this chat.'
        : 'This message will be deleted for you only. Other participants will still see it.';

    Get.defaultDialog(
      title: title,
      middleText: content,
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.black87,
      onConfirm: () async {
        Get.back(); // បិទ Dialog

        final success = await _restService.deleteMessage(
          conversationId.value!,
          message.id,
          type,
        );

        if (success) {
          // 🎯 Optimistic UI Update (ដូរ UI មុនពេល WebSocket លោតមកដល់ក៏បាន)
          if (type == 'everyone') {
            final index = messages.indexWhere((m) => m.id == message.id);
            if (index != -1) {
              messages[index] = messages[index].copyWith(
                isDeletedForEveryone: true,
                content: "",
              );
              messages.refresh();
            }
          } else {
            messages.removeWhere((m) => m.id == message.id);
            messages.refresh();
          }
        } else {
          Get.snackbar("Error", "Could not delete message. Please try again.");
        }
      },
    );
  }

  void onTextChanged(String value) {
    final id = conversationId.value;
    if (id == null) return;

    if (value.isNotEmpty && !_isTypingSent) {
      _isTypingSent = true;
      _wsService.sendEvent('typing', {
        "conversation_id": id,
        "is_typing": true,
      });
    }

    _typingStopTimer?.cancel();
    _typingStopTimer = Timer(const Duration(seconds: 2), _stopTyping);
  }

  void _stopTyping() {
    final id = conversationId.value;
    if (id != null && _isTypingSent) {
      _wsService.sendEvent('typing', {
        "conversation_id": id,
        "is_typing": false,
      });
    }
    _isTypingSent = false;
    _typingStopTimer?.cancel();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!scrollController.hasClients) return;
    if (animated) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(0);
    }
  }

  @override
  void onClose() {
    _stopTyping();
    _wsSubscription?.cancel();
    _typingStopTimer?.cancel();
    _otherTypingClearTimer?.cancel();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

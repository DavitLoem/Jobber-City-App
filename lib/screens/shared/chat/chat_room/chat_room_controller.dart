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
      setupError.value = "Invalid Arguments".tr; // 🟢 Added .tr
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
      setupError.value = 'Could not open conversation.'.tr; // 🟢 Added .tr
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
      messages.assignAll(result.messages.reversed.toList());
      _sortMessages();
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
        messages.isEmpty) {
      return;
    }
    isLoadingMore.value = true;
    try {
      final oldestId = messages.last.id;
      final result = await _restService.getMessages(
        conversationId.value!,
        before: oldestId,
      );
      messages.addAll(result.messages.reversed.toList());
      _sortMessages();
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
      _sortMessages();
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
            messages[index] = messages[index].copyWith(
              isDeletedForEveryone: true,
              content: "",
            );
            messages.refresh();
          }
        } else if (deleteType == 'me') {
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
    _sortMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final sent = await _restService.sendMessageRest(
        conversationId: id,
        content: text,
        clientTempId: clientTempId,
      );

      final idx = messages.indexWhere((m) => m.clientTempId == clientTempId);
      if (idx != -1) {
        messages[idx] = sent;
        _sortMessages();
      }
    } catch (e) {
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

  void showDeleteOptions(ChatMessage message) {
    if (message.isDeletedForEveryone || message.isPending) {
      return;
    }

    final isMine = message.senderId == currentUserId;
    final isDark = Get.isDarkMode; // 🟢 Theme Check

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceElevated
              : Colors.white, // 🟢 Dynamic BG
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Message Options".tr, // 🟢 Added .tr
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87, // 🟢 Dynamic Title
              ),
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: isDark
                    ? Colors.white70
                    : Colors.black87, // 🟢 Dynamic Icon
              ),
              title: Text(
                "Delete for me".tr, // 🟢 Added .tr
                style: TextStyle(
                  color: isDark
                      ? Colors.white70
                      : Colors.black87, // 🟢 Dynamic Text
                ),
              ),
              onTap: () {
                Get.back();
                _confirmAndDelete(message, 'me');
              },
            ),

            if (isMine)
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.redAccent,
                ),
                title: Text(
                  "Delete for everyone".tr, // 🟢 Added .tr
                  style: const TextStyle(color: Colors.redAccent),
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
              .tr // 🟢 Added .tr
        : 'Delete for Me?'.tr; // 🟢 Added .tr
    final content = type == 'everyone'
        ? 'This message will be deleted for all participants in this chat.'
              .tr // 🟢 Added .tr
        : 'This message will be deleted for you only. Other participants will still see it.'
              .tr; // 🟢 Added .tr

    final isDark = Get.isDarkMode; // 🟢 Theme Check

    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
      ), // 🟢 Dynamic Title Color
      middleText: content,
      middleTextStyle: TextStyle(
        color: isDark ? Colors.white70 : Colors.black87,
      ), // 🟢 Dynamic Middle Text
      backgroundColor: isDark
          ? AppColors.darkSurfaceElevated
          : Colors.white, // 🟢 Dynamic Background
      textCancel: 'Cancel'.tr, // 🟢 Added .tr
      textConfirm: 'Delete'.tr, // 🟢 Added .tr
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      cancelTextColor: isDark
          ? Colors.white
          : Colors.black87, // 🟢 Dynamic Cancel Color
      onConfirm: () async {
        Get.back();

        final success = await _restService.deleteMessage(
          conversationId.value!,
          message.id,
          type,
        );

        if (success) {
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
          Get.snackbar(
            "Error".tr, // 🟢 Added .tr
            "Could not delete message. Please try again.".tr, // 🟢 Added .tr
            backgroundColor: isDark
                ? AppColors.error.withValues(alpha: 0.15)
                : Colors.red.shade50,
            colorText: isDark ? Colors.redAccent : Colors.red.shade700,
          );
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

  void _sortMessages() {
    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    messages.refresh();
  }
}

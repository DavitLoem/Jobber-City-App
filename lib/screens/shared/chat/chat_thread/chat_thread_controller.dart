part of 'chat_thread_view.dart';

class ChatThreadViewController extends GetxController {
  final ChatService _chatService = ChatService();
  final ChatSocketService socket = ChatSocketService.instance;
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

  StreamSubscription? _eventsSub;
  Timer? _typingStopTimer;
  Timer? _otherTypingClearTimer;
  bool _isTypingSent = false;

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments as ChatThreadArgs;
    scrollController.addListener(_onScroll);
    _setup();
  }

  Future<void> _setup() async {
    isSettingUp.value = true;
    setupError.value = '';

    final token = await TokenStorage.getAccessToken();
    if (token != null) currentUserId = JwtUtils.getUserId(token);

    await socket.connect();
    _eventsSub = socket.events.listen(_onSocketEvent);

    try {
      if (args.conversationId != null) {
        conversationId.value = args.conversationId;
      } else {
        // Coming from a "Message" button that doesn't have a conversation
        // yet (e.g. employer messaging a candidate for the first time) —
        // get-or-create it now.
        final convo = await _chatService.startConversation(
          otherUserId: args.otherUserId!,
          jobId: args.jobId,
        );
        conversationId.value = convo.id;
      }

      await _loadInitialMessages();
      _markRead();
    } catch (e) {
      setupError.value = 'Could not open this conversation. Please go back and try again.';
      debugPrint('[ChatThread] setup error: $e');
    } finally {
      isSettingUp.value = false;
    }
  }

  Future<void> _loadInitialMessages() async {
    if (conversationId.value == null) return;
    isLoadingHistory.value = true;
    try {
      final result = await _chatService.getMessages(conversationId.value!);
      messages.assignAll(result.messages);
      hasMoreHistory.value = result.hasMore;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animated: false));
    } catch (e) {
      debugPrint('[ChatThread] load history error: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> loadMoreHistory() async {
    if (!hasMoreHistory.value || isLoadingMore.value || conversationId.value == null || messages.isEmpty) return;
    isLoadingMore.value = true;
    try {
      final oldestId = messages.first.id;
      final result = await _chatService.getMessages(conversationId.value!, before: oldestId);
      messages.insertAll(0, result.messages);
      hasMoreHistory.value = result.hasMore;
    } catch (e) {
      debugPrint('[ChatThread] load more error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    // The message list uses `reverse: true` (standard for chat UIs) so that
    // prepending older history never shifts what's currently on screen —
    // new items just get appended past the bottom of the *reversed*
    // internal list, which is visually the top, off-screen where the user
    // already scrolled to. In that coordinate space, `pixels` grows from 0
    // (newest, bottom) up to `maxScrollExtent` (oldest loaded message), so
    // "near the top of history" means close to `maxScrollExtent`.
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMoreHistory();
    }
  }

  void _markRead() {
    final id = conversationId.value;
    if (id == null) return;
    _chatService.markAsRead(id); // fire-and-forget REST (works even if socket is down)
    socket.sendRead(conversationId: id);
  }

  void _onSocketEvent(Map<String, dynamic> event) {
    final type = event['type'];

    if (type == 'new_message') {
      final data = event['data'] as Map<String, dynamic>?;
      if (data == null || data['conversation_id']?.toString() != conversationId.value) return;

      final incoming = ChatMessage.fromJson(data);

      // Optimistic-UI matching: if this is the server's echo of a message
      // we sent ourselves, replace the temporary bubble instead of adding
      // a duplicate one.
      final pendingIndex = incoming.clientTempId != null
          ? messages.indexWhere((m) => m.clientTempId == incoming.clientTempId && m.isPending)
          : -1;

      if (pendingIndex != -1) {
        messages[pendingIndex] = incoming;
      } else if (!messages.any((m) => m.id == incoming.id)) {
        messages.add(incoming);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

      if (incoming.senderId != currentUserId) {
        _markRead(); // thread is open on screen right now — it's read the instant it arrives
      }
      return;
    }

    if (type == 'typing') {
      if (event['conversation_id']?.toString() != conversationId.value) return;
      if (event['user_id']?.toString() == currentUserId) return; // ignore our own echo, if any

      isOtherPartyTyping.value = event['is_typing'] == true;
      _otherTypingClearTimer?.cancel();
      if (isOtherPartyTyping.value) {
        // Safety net: clear the indicator if a matching "stopped typing"
        // event never arrives (e.g. the other side's app was killed).
        _otherTypingClearTimer = Timer(const Duration(seconds: 6), () => isOtherPartyTyping.value = false);
      }
      return;
    }

    if (type == 'read_receipt') {
      if (event['conversation_id']?.toString() != conversationId.value) return;
      // Mark every one of MY messages as read up to now.
      for (var i = 0; i < messages.length; i++) {
        final m = messages[i];
        if (m.senderId == currentUserId && m.status != 'read') {
          messages[i] = m.copyWith(status: 'read');
        }
      }
      return;
    }

    if (type == 'error') {
      Get.snackbar('Chat error', event['message']?.toString() ?? 'Something went wrong.');
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
    messages.add(optimistic);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    if (socket.isConnected) {
      socket.sendMessage(conversationId: id, content: text, clientTempId: clientTempId);
      // Confirmation arrives via the socket's own `new_message` echo — see _onSocketEvent.
    } else {
      // Socket down — fall back to REST so the message isn't silently lost.
      try {
        final sent = await _chatService.sendMessageRest(
          conversationId: id,
          content: text,
          clientTempId: clientTempId,
        );
        final idx = messages.indexWhere((m) => m.clientTempId == clientTempId);
        if (idx != -1) messages[idx] = sent;
      } catch (e) {
        final idx = messages.indexWhere((m) => m.clientTempId == clientTempId);
        if (idx != -1) messages[idx] = messages[idx].copyWith(status: 'failed', isPending: false);
        debugPrint('[ChatThread] REST send fallback failed: $e');
      }
    }
  }

  void onTextChanged(String value) {
    final id = conversationId.value;
    if (id == null) return;

    if (value.isNotEmpty && !_isTypingSent) {
      _isTypingSent = true;
      socket.sendTyping(conversationId: id, isTyping: true);
    }

    _typingStopTimer?.cancel();
    _typingStopTimer = Timer(const Duration(seconds: 2), _stopTyping);
  }

  void _stopTyping() {
    final id = conversationId.value;
    if (id != null && _isTypingSent) {
      socket.sendTyping(conversationId: id, isTyping: false);
    }
    _isTypingSent = false;
    _typingStopTimer?.cancel();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!scrollController.hasClients) return;
    if (animated) {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      scrollController.jumpTo(0);
    }
  }

  @override
  void onClose() {
    _stopTyping();
    _eventsSub?.cancel();
    _typingStopTimer?.cancel();
    _otherTypingClearTimer?.cancel();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

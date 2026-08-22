part of 'chat_list_view.dart';

class ChatListViewController extends GetxController {
  final ChatService _chatService = ChatService();
  final ChatSocketService socket = ChatSocketService.instance;

  final conversations = <ChatConversation>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final isEmployer = false.obs;
  String? currentUserId;

  StreamSubscription? _eventsSub;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) currentUserId = JwtUtils.getUserId(token);

    // Only employers can browse the full seeker directory to start a new
    // chat (backend endpoint is employer-only) — seekers keep messaging
    // employers only via the existing "Message" button on job/company screens.
    final role = await TokenStorage.getUserRole();
    isEmployer.value = role == 'employer';

    // Fire-and-forget: the list still loads over REST even if the socket is
    // slow to connect, it just won't get live updates until it's up.
    socket.connect();
    _eventsSub = socket.events.listen(_onSocketEvent);

    await fetchConversations();
  }

  Future<void> fetchConversations({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _chatService.listConversations();
      conversations.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Could not load your conversations. Pull down to try again.';
      debugPrint('[ChatList] fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _onSocketEvent(Map<String, dynamic> event) {
    if (event['type'] != 'new_message') return;
    final data = event['data'] as Map<String, dynamic>?;
    if (data == null) return;

    final conversationId = data['conversation_id']?.toString();
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index == -1) {
      // Message on a conversation we don't have loaded yet (first message
      // from someone new) — cheapest correct fix is a quiet refetch.
      fetchConversations(silent: true);
      return;
    }

    final convo = conversations[index];
    final isFromMe = data['sender_id']?.toString() == currentUserId;
    final messageType = data['message_type']?.toString() ?? 'text';

    final updated = ChatConversation(
      id: convo.id,
      jobId: convo.jobId,
      otherParty: convo.otherParty,
      lastMessage: messageType == 'text' ? data['content']?.toString() : '[${messageType[0].toUpperCase()}${messageType.substring(1)}]',
      lastMessageType: messageType,
      lastMessageAt: DateTime.tryParse(data['created_at']?.toString() ?? '')?.toLocal() ?? DateTime.now(),
      lastSenderId: data['sender_id']?.toString(),
      unreadCount: isFromMe ? convo.unreadCount : convo.unreadCount + 1,
      createdAt: convo.createdAt,
    );

    conversations.removeAt(index);
    conversations.insert(0, updated); // bump to top, like every real chat app
  }

  Future<void> openConversation(ChatConversation convo) async {
    // Optimistically clear the unread badge the moment they tap in — the
    // thread screen itself sends the real `read` event over the socket.
    final index = conversations.indexWhere((c) => c.id == convo.id);
    if (index != -1 && conversations[index].unreadCount > 0) {
      final c = conversations[index];
      conversations[index] = ChatConversation(
        id: c.id,
        jobId: c.jobId,
        otherParty: c.otherParty,
        lastMessage: c.lastMessage,
        lastMessageType: c.lastMessageType,
        lastMessageAt: c.lastMessageAt,
        lastSenderId: c.lastSenderId,
        unreadCount: 0,
        createdAt: c.createdAt,
      );
    }

    await Get.toNamed(
      AppRoutes.chatThread,
      arguments: ChatThreadArgs(
        conversationId: convo.id,
        otherPartyName: convo.otherParty.name,
        otherPartyAvatarUrl: convo.otherParty.avatarUrl,
        otherPartyRole: convo.otherParty.role,
        jobId: convo.jobId,
      ),
    );

    // Back from the thread — resync in case new messages arrived while there.
    fetchConversations(silent: true);
  }

  @override
  void onClose() {
    _eventsSub?.cancel();
    super.onClose();
  }
}

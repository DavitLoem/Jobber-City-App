part of 'conversation_list_view.dart';

class ConversationListViewController extends GetxController {
  final ChatRestService _restService = Get.find<ChatRestService>();
  final ChatWsService _wsService = Get.find<ChatWsService>();

  final conversations = <ChatConversation>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  String? currentUserId;

  StreamSubscription? _wsSubscription;

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isEmployer = false.obs;

  @override
  void onInit() {
    super.onInit();
    _init();

    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  Future<void> _init() async {
    currentUserId = await TokenStorage.getUserId();

    // 🎯 ឆែកមើល Role ថាជា Employer ឫ Seeker
    final role = await TokenStorage.getUserRole();
    isEmployer.value = (role == 'employer');

    await fetchConversations();
    _listenToRealTimeEvents();
  }

  List<ChatConversation> get filteredConversations {
    if (searchQuery.value.isEmpty) {
      return conversations;
    }
    return conversations.where((convo) {
      return convo.otherParty.name.toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );
    }).toList();
  }

  Future<void> fetchConversations({bool silent = false}) async {
    if (!silent) isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _restService.listConversations(page: 1, limit: 20);
      conversations.assignAll(result);
    } catch (e) {
      errorMessage.value =
          'Could not load your conversations. Pull down to try again.'
              .tr; // 🟢 Added .tr
      debugPrint('[ChatList] fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _listenToRealTimeEvents() {
    _wsSubscription = _wsService.messageStream.listen((event) {
      if (event['type'] != 'new_message') return;

      final newMsg = ChatMessage.fromJson(event['data']);
      final index = conversations.indexWhere(
        (c) => c.id == newMsg.conversationId,
      );

      if (index == -1) {
        fetchConversations(silent: true);
        return;
      }

      final convo = conversations[index];
      final isFromMe = newMsg.senderId == currentUserId;
      final previewText = newMsg.messageType == 'text'
          ? newMsg.content
          : '[${newMsg.messageType[0].toUpperCase()}${newMsg.messageType.substring(1)}]'
                .tr; // 🟢 Translate media types if needed

      final updatedConvo = convo.copyWith(
        lastMessage: previewText,
        lastMessageType: newMsg.messageType,
        lastMessageAt: newMsg.createdAt,
        unreadCount: isFromMe ? convo.unreadCount : convo.unreadCount + 1,
      );

      conversations.removeAt(index);
      conversations.insert(0, updatedConvo);
    });
  }

  Future<void> openConversation(ChatConversation convo) async {
    final index = conversations.indexWhere((c) => c.id == convo.id);
    if (index != -1 && conversations[index].unreadCount > 0) {
      conversations[index] = conversations[index].copyWith(unreadCount: 0);
      conversations.refresh();
    }

    await Get.toNamed(
      AppRoutes.chatRoom,
      arguments: ChatThreadArgs(
        conversationId: convo.id,
        otherPartyName: convo.otherParty.name,
        otherPartyAvatarUrl: convo.otherParty.avatarUrl,
        otherPartyRole: convo.otherParty.role,
        jobId: convo.jobId,
      ),
    );

    fetchConversations(silent: true);
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    super.onClose();
  }
}

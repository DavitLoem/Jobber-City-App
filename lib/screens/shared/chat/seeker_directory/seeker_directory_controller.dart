part of 'seeker_directory_view.dart';

class SeekerDirectoryController extends GetxController {
  final ChatService _chatService = ChatService();
  final _debouncer = Debouncer(milliseconds: 400);
  final searchController = TextEditingController();

  final seekers = <SeekerDirectoryItem>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final startingChatWith = RxnString();
  bool hasMore = true;
  int _page = 1;
  String _search = '';

  @override
  void onInit() {
    super.onInit();
    fetchSeekers();
  }

  void onSearchChanged(String value) {
    _debouncer.run(() {
      _search = value.trim();
      fetchSeekers();
    });
  }

  Future<void> fetchSeekers() async {
    isLoading.value = true;
    errorMessage.value = '';
    _page = 1;
    try {
      final result = await _chatService.listAllSeekers(search: _search, page: _page);
      seekers.assignAll(result.items);
      hasMore = result.hasMore;
    } catch (e) {
      errorMessage.value = 'Could not load seekers. Pull down to try again.';
      debugPrint('[SeekerDirectory] fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final result = await _chatService.listAllSeekers(search: _search, page: nextPage);
      seekers.addAll(result.items);
      hasMore = result.hasMore;
      _page = nextPage;
    } catch (e) {
      debugPrint('[SeekerDirectory] loadMore error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> startChatWith(SeekerDirectoryItem seeker) async {
    if (startingChatWith.value != null) return;
    startingChatWith.value = seeker.seekerUserId;
    try {
      final convo = await _chatService.startConversation(otherUserId: seeker.seekerUserId);
      Get.back(); // close the directory, go back to the (now-updated) inbox
      await Get.toNamed(
        AppRoutes.chatThread,
        arguments: ChatThreadArgs(
          conversationId: convo.id,
          otherPartyName: seeker.fullName,
          otherPartyAvatarUrl: seeker.profileImageUrl,
          otherPartyRole: 'seeker',
        ),
      );
    } catch (e) {
      debugPrint('[SeekerDirectory] startChatWith error: $e');
      Get.snackbar('Could not start chat', 'Please try again.');
    } finally {
      startingChatWith.value = null;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

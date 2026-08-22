class ChatOtherParty {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String role;
  final bool isOnline;

  ChatOtherParty({
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.role,
    required this.isOnline,
  });

  factory ChatOtherParty.fromJson(Map<String, dynamic> json) => ChatOtherParty(
    userId: json['user_id']?.toString() ?? '',
    name: json['name']?.toString() ?? 'Unknown',
    avatarUrl:
        json['avatar_url']?.toString() ?? json['profile_image_url']?.toString(),
    role: json['role']?.toString() ?? '',
    isOnline: json['is_online'] == true,
  );
}

class ChatConversation {
  final String id;
  final String? jobId;
  final ChatOtherParty otherParty;
  final String? lastMessage;
  final String? lastMessageType;
  final DateTime? lastMessageAt;
  final String? lastSenderId;
  int unreadCount;
  final DateTime createdAt;

  ChatConversation({
    required this.id,
    this.jobId,
    required this.otherParty,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageAt,
    this.lastSenderId,
    required this.unreadCount,
    required this.createdAt,
  });

  // 🎯 មុខងារថ្មីដែលយើងបន្ថែម ដើម្បីជំនួយដល់ Real-time Update
  ChatConversation copyWith({
    String? lastMessage,
    String? lastMessageType,
    DateTime? lastMessageAt,
    int? unreadCount,
  }) {
    return ChatConversation(
      id: id,
      jobId: jobId,
      otherParty: otherParty,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastSenderId: lastSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt,
    );
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        id: json['id']?.toString() ?? '',
        jobId: json['job_id']?.toString(),
        otherParty: ChatOtherParty.fromJson(json['other_party'] ?? {}),
        lastMessage: json['last_message'],
        lastMessageType: json['last_message_type'],
        lastMessageAt: json['last_message_at'] != null
            ? DateTime.tryParse(json['last_message_at'].toString())?.toLocal()
            : null,
        lastSenderId: json['last_sender_id']?.toString(),
        unreadCount: json['unread_count'] ?? 0,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())?.toLocal() ??
                  DateTime.now()
            : DateTime.now(),
      );
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderRole;
  final String messageType;
  final String content;
  final String? attachmentUrl;
  String status;
  final String? clientTempId;
  final DateTime createdAt;
  bool isPending;
  final bool isDeletedForEveryone;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderRole,
    required this.messageType,
    required this.content,
    this.attachmentUrl,
    required this.status,
    this.clientTempId,
    required this.createdAt,
    this.isPending = false,
    this.isDeletedForEveryone = false,
  });

  ChatMessage copyWith({
    String? id,
    String? status,
    bool? isPending,
    String? content,
    bool? isDeletedForEveryone,
  }) => ChatMessage(
    id: id ?? this.id,
    conversationId: conversationId,
    senderId: senderId,
    senderRole: senderRole,
    messageType: messageType,
    content: content ?? this.content,
    attachmentUrl: attachmentUrl,
    status: status ?? this.status,
    clientTempId: clientTempId,
    createdAt: createdAt,
    isPending: isPending ?? this.isPending,
    isDeletedForEveryone: isDeletedForEveryone ?? this.isDeletedForEveryone,
  );

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id']?.toString() ?? '',
    conversationId: json['conversation_id']?.toString() ?? '',
    senderId: json['sender_id']?.toString() ?? '',
    senderRole: json['sender_role']?.toString() ?? '',
    messageType: json['message_type']?.toString() ?? 'text',
    content: json['content']?.toString() ?? '',
    attachmentUrl: json['attachment_url'],
    status: json['status']?.toString() ?? 'sent',
    clientTempId: json['client_temp_id']?.toString(),
    createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())?.toLocal() ??
              DateTime.now()
        : DateTime.now(),
    isDeletedForEveryone: json['is_deleted_for_everyone'] == true,
  );
}

// 🎯 ChatThreadArgs រក្សាទុកដដែលព្រោះវាល្អស្រាប់ហើយ
class ChatThreadArgs {
  final String? conversationId;
  final String? otherUserId;
  final String otherPartyName;
  final String? otherPartyAvatarUrl;
  final String otherPartyRole;
  final String? jobId;

  ChatThreadArgs({
    this.conversationId,
    this.otherUserId,
    required this.otherPartyName,
    this.otherPartyAvatarUrl,
    required this.otherPartyRole,
    this.jobId,
  }) : assert(
         conversationId != null || otherUserId != null,
         'ChatThreadArgs needs either an existing conversationId or an otherUserId to start one.',
       );
}

class SeekerDirectoryItem {
  final String seekerUserId;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final String? currentPosition;
  final bool hasAppliedToYou;

  SeekerDirectoryItem({
    required this.seekerUserId,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    this.currentPosition,
    required this.hasAppliedToYou,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory SeekerDirectoryItem.fromJson(Map<String, dynamic> json) =>
      SeekerDirectoryItem(
        seekerUserId: json['seeker_user_id']?.toString() ?? '',
        firstName: json['first_name']?.toString() ?? 'Unknown',
        lastName: json['last_name']?.toString() ?? '',
        profileImageUrl: json['profile_image_url'],
        currentPosition: json['current_position'],
        hasAppliedToYou: json['has_applied_to_you'] == true,
      );
}

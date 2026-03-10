class ConversationSummary {
  ConversationSummary({
    required this.conversationId,
    required this.relationStatus,
    required this.boundAt,
    required this.partnerId,
    required this.partnerNickname,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.isPinned,
  });

  final String conversationId;
  final String relationStatus;
  final String boundAt;
  final String partnerId;
  final String partnerNickname;
  final String lastMessage;
  final String lastMessageAt;
  final int unreadCount;
  final bool isPinned;

  ConversationSummary copyWith({
    String? conversationId,
    String? relationStatus,
    String? boundAt,
    String? partnerId,
    String? partnerNickname,
    String? lastMessage,
    String? lastMessageAt,
    int? unreadCount,
    bool? isPinned,
  }) {
    return ConversationSummary(
      conversationId: conversationId ?? this.conversationId,
      relationStatus: relationStatus ?? this.relationStatus,
      boundAt: boundAt ?? this.boundAt,
      partnerId: partnerId ?? this.partnerId,
      partnerNickname: partnerNickname ?? this.partnerNickname,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

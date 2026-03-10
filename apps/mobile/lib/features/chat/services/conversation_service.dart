import "../../../core/api_client.dart";
import "../models/conversation_summary.dart";

class ConversationService {
  ConversationService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<ConversationSummary>> listConversations() async {
    final meResult = await apiClient.me();
    final currentUserId = meResult["success"] == true
        ? (((meResult["data"] as Map<String, dynamic>)["user"] as Map<String, dynamic>?)?["id"] as String?)
        : null;

    final relationResult = await apiClient.latestRelation();
    if (relationResult["success"] != true) {
      final code = ((relationResult["error"] as Map?)?["code"] as String?) ?? "";
      if (code == "RELATION_404_NOT_BOUND") {
        return [];
      }
      throw StateError("Failed to load current relation");
    }

    final relation = ((relationResult["data"] as Map<String, dynamic>)["relation"] as Map<String, dynamic>?);
    if (relation == null) return [];
    final partner = relation["partner"] as Map<String, dynamic>?;
    final relationId = (relation["relationId"] as String?) ?? "current";
    final relationStatus = (relation["status"] as String?) ?? "active";
    final boundAt = (relation["boundAt"] as String?) ?? "";
    final partnerId = (partner?["id"] as String?) ?? "";
    final partnerNickname = (partner?["nickname"] as String?) ?? "";

    final msgResult = await apiClient.fetchMessages(limit: 50, includeArchived: true);
    String preview = "";
    String lastAt = "";
    var unread = 0;
    if (msgResult["success"] != true) {
      throw StateError("Failed to load messages");
    }

    final items =
        ((msgResult["data"] as Map<String, dynamic>)["items"] as List<dynamic>? ?? [])
            .cast<Map<String, dynamic>>();
    if (items.isNotEmpty) {
      preview = (items.first["content"] as String?) ?? preview;
      lastAt = (items.first["createdAt"] as String?) ?? "";
    }
    if (currentUserId != null && currentUserId.isNotEmpty) {
      unread = items
          .where((m) {
            final senderId = m["senderId"] as String?;
            final readAt = m["readAt"] as String?;
            return senderId != null &&
                senderId != currentUserId &&
                (readAt == null || readAt.isEmpty);
          })
          .length;
    }

    return [
      ConversationSummary(
        conversationId: relationId,
        relationStatus: relationStatus,
        boundAt: boundAt,
        partnerId: partnerId,
        partnerNickname: partnerNickname,
        lastMessage: preview,
        lastMessageAt: lastAt,
        unreadCount: unread,
        isPinned: false,
      ),
    ];
  }
}

import "package:flutter/material.dart";
import "dart:math";

import "../../core/api_client.dart";
import "../../core/i18n/app_localizers.dart";
import "../../core/i18n/app_strings.dart";
import "../auth/login_page.dart";
import "widgets/chat_bubble.dart";
import "widgets/chat_states_sheet.dart";

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.apiClient,
    this.readOnly = false,
    this.initialPartnerNickname,
  });

  final ApiClient apiClient;
  final bool readOnly;
  final String? initialPartnerNickname;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final inputCtrl = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String? error;
  String? failedContent;
  String? currentUserId;
  String? currentUserNickname;
  String? partnerNickname;
  bool loading = false;
  bool sending = false;
  bool syncing = false;
  bool readOnly = false;
  int msgCounter = 0;
  final _rand = Random();
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _bootstrap();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    inputCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncOnResume();
    }
  }

  Future<void> _bootstrap() async {
    readOnly = widget.readOnly;
    partnerNickname = widget.initialPartnerNickname;
    await _loadCurrentUser();
    await _loadPartnerInfo();
    await _refreshMessages(showPageLoading: true);
    await _markUnreadAsRead();
  }

  Future<void> _loadCurrentUser() async {
    final s = AppStrings.of(context);
    final result = await widget.apiClient.me();
    if (!mounted) return;
    if (result["success"] == true) {
      final user = (result["data"] as Map<String, dynamic>)["user"] as Map<String, dynamic>;
      setState(() {
        currentUserId = user["id"] as String?;
        currentUserNickname = user["nickname"] as String?;
        // Reset transient states on identity load to avoid cross-account residue.
        messages = [];
        inputCtrl.clear();
        msgCounter = 0;
        sending = false;
      });
    } else {
      setState(() {
        error = AppLocalizers.apiError(
          s,
          (result["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorLoadUserFailed",
        );
      });
    }
  }

  Future<void> _loadPartnerInfo() async {
    final result = await widget.apiClient.latestRelation();
    if (!mounted) return;
    if (result["success"] == true) {
      final relation = (result["data"] as Map<String, dynamic>)["relation"] as Map<String, dynamic>;
      final partner = relation["partner"] as Map<String, dynamic>?;
      setState(() {
        partnerNickname = partner?["nickname"] as String?;
        readOnly = ((relation["status"] as String?) ?? "active") != "active";
      });
    }
  }

  Future<void> _refreshMessages({bool showPageLoading = false}) async {
    final s = AppStrings.of(context);
    if (showPageLoading) {
      setState(() {
        loading = true;
        error = null;
      });
    }
    final result = await widget.apiClient.fetchMessages(limit: 50, includeArchived: true);
    if (!mounted) return;
    if (result["success"] == true) {
      final items =
          ((result["data"] as Map<String, dynamic>)["items"] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
      setState(() {
        messages = items;
        final serverReadOnly =
            ((result["data"] as Map<String, dynamic>)["readOnly"] as bool?) ?? false;
        readOnly = readOnly || serverReadOnly;
        if (showPageLoading) {
          loading = false;
        }
      });
    } else {
      setState(() {
        if (showPageLoading) {
          loading = false;
        }
        error = AppLocalizers.apiError(
          s,
          (result["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorLoadMessagesFailed",
        );
      });
    }
  }

  Future<void> _syncOnResume() async {
    if (syncing) return;
    setState(() => syncing = true);
    await _refreshMessages(showPageLoading: false);
    await _markUnreadAsRead();
    if (!mounted) return;
    setState(() => syncing = false);
  }

  Future<void> _markUnreadAsRead() async {
    if (readOnly || currentUserId == null || messages.isEmpty) return;
    final unreadIds = messages
        .where((m) {
          final senderId = m["senderId"] as String?;
          final readAt = m["readAt"] as String?;
          return senderId != null &&
              senderId != currentUserId &&
              (readAt == null || readAt.isEmpty);
        })
        .map((m) => m["id"] as String?)
        .whereType<String>()
        .toList();
    if (unreadIds.isEmpty) return;

    try {
      await widget.apiClient.markMessagesRead(messageIds: unreadIds);
    } catch (_) {
      // Ignore read sync errors in passive flow.
    }
  }

  Future<void> _send() async {
    final s = AppStrings.of(context);
    if (readOnly || inputCtrl.text.trim().isEmpty || sending) return;
    final content = inputCtrl.text.trim();
    msgCounter += 1;
    final clientMsgId = _buildClientMsgId();
    setState(() {
      sending = true;
      error = null;
    });
    final result = await widget.apiClient.sendMessage(
      clientMsgId: clientMsgId,
      content: content,
    );
    if (!mounted) return;
    if (result["success"] == true) {
      inputCtrl.clear();
      final idempotentHit = ((result["data"] as Map<String, dynamic>)["idempotentHit"] as bool?) ?? false;
      if (idempotentHit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.t("duplicateRequestMerged"))),
        );
      }
      await _refreshMessages(showPageLoading: false);
      await _markUnreadAsRead();
      setState(() {
        sending = false;
        failedContent = null;
      });
    } else {
      setState(() {
        error = AppLocalizers.apiError(
          s,
          (result["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorSendFailed",
        );
        failedContent = content;
        sending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? s.t("errorSendFailed"))),
      );
    }
  }

  Future<void> _retryLastFailed() async {
    if (failedContent == null || failedContent!.isEmpty || sending) return;
    inputCtrl.text = failedContent!;
    await _send();
  }

  String _buildClientMsgId() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final nonce = _rand.nextInt(1 << 20).toRadixString(36).padLeft(4, "0");
    return "m_${ts}_$nonce";
  }

  void _openStatesSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => const ChatStatesSheet(),
    );
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return "";
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return "";
    final hh = dt.hour.toString().padLeft(2, "0");
    final mm = dt.minute.toString().padLeft(2, "0");
    return "$hh:$mm";
  }

  String _avatarLabel(String? senderId, bool isSelf) {
    if (isSelf && (currentUserNickname?.isNotEmpty ?? false)) {
      return currentUserNickname!.substring(0, 1).toUpperCase();
    }
    if (!isSelf && (partnerNickname?.isNotEmpty ?? false)) {
      return partnerNickname!.substring(0, 1).toUpperCase();
    }
    if (isSelf) return "M";
    if (senderId == null || senderId.isEmpty) return "P";
    return senderId.substring(0, 1).toUpperCase();
  }

  Color _avatarBgColor(String seed) {
    const palette = <Color>[
      Color(0xFFE3F2FD),
      Color(0xFFE8F5E9),
      Color(0xFFFFF3E0),
      Color(0xFFF3E5F5),
      Color(0xFFE0F2F1),
      Color(0xFFFFEBEE),
    ];
    final hash = seed.codeUnits.fold<int>(0, (acc, n) => acc + n);
    return palette[hash % palette.length];
  }

  void _backToLogin() {
    widget.apiClient.token = null;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage(apiClient: widget.apiClient)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(partnerNickname?.isNotEmpty == true ? partnerNickname! : s.t("chat")),
        actions: [
          IconButton(
            onPressed: _backToLogin,
            icon: const Icon(Icons.logout),
            tooltip: s.t("backToLogin"),
          ),
          IconButton(
            onPressed: () => _refreshMessages(showPageLoading: false),
            icon: const Icon(Icons.refresh),
            tooltip: s.t("syncNow"),
          ),
          IconButton(
            onPressed: _openStatesSheet,
            icon: const Icon(Icons.tune),
            tooltip: s.t("uiStates"),
          ),
        ],
      ),
      body: Column(
        children: [
          if (partnerNickname != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: _avatarBgColor(partnerNickname!),
                    child: Text(
                      partnerNickname!.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${s.t("partner")}: $partnerNickname",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    readOnly ? s.t("historyReadOnly") : s.t("bound"),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          s.t("noMessagesFirst"),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: messages.length,
                        itemBuilder: (_, i) {
                          final msg = messages[i];
                          final senderId = msg["senderId"] as String?;
                          final isSelf = currentUserId != null && senderId == currentUserId;
                          return ChatBubble(
                            content: (msg["content"] as String?) ?? "",
                            timeText: _formatTime(msg["createdAt"] as String?),
                            isSelf: isSelf,
                            avatarLabel: _avatarLabel(senderId, isSelf),
                            avatarBackgroundColor: _avatarBgColor(
                              isSelf
                                  ? (currentUserNickname ?? "self")
                                  : (partnerNickname ?? senderId ?? "peer"),
                            ),
                          );
                        },
                      ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
          if (failedContent != null && failedContent!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${s.t("errorSendFailed")}: $failedContent",
                      style: const TextStyle(color: Colors.orange),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: sending ? null : _retryLastFailed,
                    child: Text(s.t("retrySend")),
                  ),
                ],
              ),
            ),
          if (readOnly)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                s.t("historyReadOnlyDesc"),
                style: const TextStyle(color: Colors.grey),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: inputCtrl,
                      decoration: InputDecoration(hintText: s.t("typeMessage")),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: sending ? null : _send,
                    child: sending
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(s.t("send")),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

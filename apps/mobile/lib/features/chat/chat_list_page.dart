import "package:flutter/material.dart";

import "../../core/app/app_settings_scope.dart";
import "../../core/app/app_theme.dart";
import "../../core/account_store.dart";
import "../../core/api_client.dart";
import "../../core/i18n/app_localizers.dart";
import "../../core/i18n/app_strings.dart";
import "../auth/login_page.dart";
import "../relation/bind_page.dart";
import "chat_page.dart";
import "models/conversation_summary.dart";
import "services/conversation_service.dart";

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late final ConversationService _service;
  final AccountStore _accountStore = AccountStore();
  List<ConversationSummary> conversations = [];
  List<SavedAccount> savedAccounts = [];
  final Set<String> pinnedConversationIds = <String>{};
  final Set<String> mutedConversationIds = <String>{};
  Map<String, dynamic>? relation;
  Map<String, dynamic>? me;
  int savedAccountCount = 0;
  bool loading = false;
  bool contactsLoading = false;
  bool meLoading = false;
  bool accountActionLoading = false;
  String? error;
  String? contactsError;
  String? meError;

  @override
  void initState() {
    super.initState();
    _service = ConversationService(apiClient: widget.apiClient);
    _loadConversations();
    _loadContacts();
    _loadMeTab();
    _loadSavedAccounts();
  }

  Future<void> _loadConversations() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final items = await _service.listConversations();
      if (!mounted) return;
      setState(() {
        conversations = items;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = AppStrings.of(context).t("errorLoadConversationsFailed");
      });
    }
  }

  void _logout() {
    widget.apiClient.clearToken();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage(apiClient: widget.apiClient)),
      (_) => false,
    );
  }

  void _goBind() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => BindPage(apiClient: widget.apiClient)),
    );
  }

  void _goLoginForSwitch() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage(apiClient: widget.apiClient)),
      (_) => false,
    );
  }

  Future<void> _loadSavedAccounts() async {
    final accounts = await _accountStore.list();
    if (!mounted) return;
    setState(() {
      savedAccounts = accounts;
      savedAccountCount = accounts.length;
    });
  }

  Future<void> _switchSavedAccount(SavedAccount account) async {
    final s = AppStrings.of(context);
    if (account.needsRelogin || account.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.t("tokenExpiredPleaseLogin"))),
      );
      _goLoginForSwitch();
      return;
    }

    setState(() {
      accountActionLoading = true;
      meError = null;
    });
    widget.apiClient.setToken(account.token);
    final meResult = await widget.apiClient.me();
    if (!mounted) return;
    if (meResult["success"] != true) {
      await _accountStore.markNeedsRelogin(account.userId);
      await _loadSavedAccounts();
      if (!mounted) return;
      widget.apiClient.clearToken();
      setState(() => accountActionLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.t("tokenExpiredPleaseLogin"))),
      );
      _goLoginForSwitch();
      return;
    }
    await _accountStore.touch(account.userId);
    await _loadSavedAccounts();
    await _loadConversations();
    await _loadContacts();
    await _loadMeTab();
    if (!mounted) return;
    setState(() => accountActionLoading = false);
  }

  Future<void> _removeSavedAccount(String userId) async {
    await _accountStore.remove(userId);
    await _loadSavedAccounts();
  }

  Future<void> _confirmAndUnbind() async {
    final s = AppStrings.of(context);
    final shouldUnbind = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(s.t("unbindConfirmTitle")),
          content: Text(s.t("unbindConfirmDesc")),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(s.t("cancel")),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(s.t("confirm")),
            ),
          ],
        );
      },
    );
    if (shouldUnbind != true) return;

    final result = await widget.apiClient.unbindRelation();
    if (!mounted) return;
    if (result["success"] != true) {
      final msg = AppLocalizers.apiError(
        s,
        (result["error"] as Map?)?.cast<String, dynamic>(),
        fallbackKey: "errorUnbindFailed",
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    await _loadContacts();
    await _loadConversations();
  }

  Future<void> _loadContacts() async {
    setState(() {
      contactsLoading = true;
      contactsError = null;
    });
    final result = await widget.apiClient.currentRelation();
    if (!mounted) return;
    if (result["success"] == true) {
      setState(() {
        relation = ((result["data"] as Map<String, dynamic>)["relation"] as Map<String, dynamic>?);
        contactsLoading = false;
      });
      return;
    }
    final code = ((result["error"] as Map?)?["code"] as String?) ?? "";
    if (code == "RELATION_404_NOT_BOUND") {
      final latest = await widget.apiClient.latestRelation();
      if (!mounted) return;
      if (latest["success"] == true) {
        setState(() {
          relation = ((latest["data"] as Map<String, dynamic>)["relation"] as Map<String, dynamic>?);
          contactsLoading = false;
        });
        return;
      }
      setState(() {
        relation = null;
        contactsLoading = false;
      });
      return;
    }
    setState(() {
      contactsLoading = false;
      contactsError = AppLocalizers.apiError(
        AppStrings.of(context),
        (result["error"] as Map?)?.cast<String, dynamic>(),
        fallbackKey: "errorLoadRelationFailed",
      );
    });
  }

  Future<void> _loadMeTab() async {
    setState(() {
      meLoading = true;
      meError = null;
    });
    final meResult = await widget.apiClient.me();
    final accounts = await _accountStore.list();
    if (!mounted) return;
    if (meResult["success"] == true) {
      setState(() {
        me = ((meResult["data"] as Map<String, dynamic>)["user"] as Map<String, dynamic>?);
        savedAccountCount = accounts.length;
        meLoading = false;
      });
      return;
    }
    setState(() {
      savedAccountCount = accounts.length;
      meLoading = false;
      meError = AppLocalizers.apiError(
        AppStrings.of(context),
        (meResult["error"] as Map?)?.cast<String, dynamic>(),
        fallbackKey: "errorLoadProfileFailed",
      );
    });
  }

  String _formatTime(String iso) {
    if (iso.isEmpty) return "";
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return "";
    final hh = dt.hour.toString().padLeft(2, "0");
    final mm = dt.minute.toString().padLeft(2, "0");
    return "$hh:$mm";
  }

  List<ConversationSummary> get _displayConversations {
    final items = [...conversations];
    items.sort((a, b) {
      final aPinned = pinnedConversationIds.contains(a.conversationId);
      final bPinned = pinnedConversationIds.contains(b.conversationId);
      if (aPinned != bPinned) return aPinned ? -1 : 1;
      return b.lastMessageAt.compareTo(a.lastMessageAt);
    });
    return items;
  }

  void _togglePin(String conversationId) {
    setState(() {
      if (pinnedConversationIds.contains(conversationId)) {
        pinnedConversationIds.remove(conversationId);
      } else {
        pinnedConversationIds.add(conversationId);
      }
    });
  }

  void _toggleMute(String conversationId) {
    setState(() {
      if (mutedConversationIds.contains(conversationId)) {
        mutedConversationIds.remove(conversationId);
      } else {
        mutedConversationIds.add(conversationId);
      }
    });
  }

  Widget _buildChatsTab() {
    final s = AppStrings.of(context);
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadConversations,
              child: Text(s.t("retry")),
            ),
          ],
        ),
      );
    }
    if (conversations.isEmpty) {
      return Center(
        child: Text(
          s.t("noConversations"),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadConversations,
      child: ListView.separated(
        itemCount: _displayConversations.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final item = _displayConversations[i];
          final isPinned = pinnedConversationIds.contains(item.conversationId);
          final isMuted = mutedConversationIds.contains(item.conversationId);
          final partnerName = item.partnerNickname.isNotEmpty ? item.partnerNickname : s.t("partner");
          final previewText =
              item.lastMessage.isNotEmpty ? item.lastMessage : s.t("noMessagesYet");
          return ListTile(
            minVerticalPadding: 10,
            leading: CircleAvatar(
              child: Text(
                partnerName.substring(0, 1).toUpperCase(),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          partnerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPinned) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.push_pin, size: 14, color: Colors.orange),
                      ],
                      if (isMuted) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.volume_off, size: 14, color: Colors.grey),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(item.lastMessageAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              previewText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == "pin") _togglePin(item.conversationId);
                if (value == "mute") _toggleMute(item.conversationId);
              },
              itemBuilder: (_) => [
                PopupMenuItem<String>(
                  value: "pin",
                  child: Text(isPinned ? s.t("unpin") : s.t("pinToTop")),
                ),
                PopupMenuItem<String>(
                  value: "mute",
                  child: Text(isMuted ? s.t("unmute") : s.t("muteNotifications")),
                ),
              ],
              child: item.unreadCount > 0 && !isMuted
                  ? CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        item.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    )
                  : const Icon(Icons.more_horiz, color: Colors.grey),
            ),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    apiClient: widget.apiClient,
                    readOnly: item.relationStatus != "active",
                    initialPartnerNickname: partnerName,
                  ),
                ),
              );
              if (!mounted) return;
              await _loadConversations();
            },
          );
        },
      ),
    );
  }

  Widget _buildContactsTab() {
    final s = AppStrings.of(context);
    if (contactsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (contactsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(contactsError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadContacts,
              child: Text(s.t("refresh")),
            ),
          ],
        ),
      );
    }
    if (relation == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.archive_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        s.t("archivedHistoryTitle"),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.t("archivedHistoryDesc"),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    s.t("notBoundYet"),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _goBind,
                    child: Text(s.t("goBind")),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final partner = relation?["partner"] as Map<String, dynamic>?;
    final partnerName = (partner?["nickname"] as String?) ?? s.t("partner");
    final boundAt = (relation?["boundAt"] as String?) ?? "";
    final relationStatusRaw = (relation?["status"] as String?) ?? "";
    final isActiveRelation = relationStatusRaw == "active";
    final status = AppLocalizers.relationStatus(s, relationStatusRaw);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text(partnerName.substring(0, 1).toUpperCase()),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        partnerName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Chip(
                      label: Text(isActiveRelation ? s.t("bound") : s.t("historyReadOnly")),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text("${s.t("status")}: $status"),
                if (boundAt.isNotEmpty) Text("${s.t("boundAt")}: $boundAt"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _loadContacts,
                child: Text(s.t("refresh")),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        apiClient: widget.apiClient,
                        readOnly: !isActiveRelation,
                        initialPartnerNickname: partnerName,
                      ),
                    ),
                  );
                },
                child: Text(
                  isActiveRelation ? s.t("openChat") : s.t("viewHistoryChat"),
                ),
              ),
            ),
          ],
        ),
        if (isActiveRelation) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _confirmAndUnbind,
              child: Text(
                s.t("unbindRelation"),
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMeTab() {
    final s = AppStrings.of(context);
    final settings = AppSettingsScope.of(context);
    if (meLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (meError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(meError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadMeTab,
              child: Text(s.t("refresh")),
            ),
          ],
        ),
      );
    }

    final nickname = (me?["nickname"] as String?) ?? "-";
    final account = (me?["account"] as String?) ?? "-";
    final userId = (me?["id"] as String?) ?? "-";

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                (nickname.isNotEmpty && nickname != "-" ? nickname : account)
                    .substring(0, 1)
                    .toUpperCase(),
              ),
            ),
            title: Text(nickname),
            subtitle: Text(account),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.t("savedAccounts"),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (savedAccounts.isEmpty)
                  Text(
                    s.t("noSavedAccounts"),
                    style: const TextStyle(color: Colors.grey),
                  )
                else
                  ...savedAccounts.map(
                    (acc) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Text(
                          (acc.nickname.isNotEmpty ? acc.nickname : acc.account)
                              .substring(0, 1)
                              .toUpperCase(),
                        ),
                      ),
                      title: Text(acc.nickname.isNotEmpty ? acc.nickname : acc.account),
                      subtitle: Text(acc.account),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ((me?["id"] as String?) == acc.userId)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Chip(
                                label: Text(s.t("currentAccount")),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          IconButton(
                            onPressed: accountActionLoading
                                ? null
                                : () => _switchSavedAccount(acc),
                            icon: const Icon(Icons.switch_account),
                            tooltip: s.t("switchAccount"),
                          ),
                          IconButton(
                            onPressed: accountActionLoading
                                ? null
                                : () => _removeSavedAccount(acc.userId),
                            icon: const Icon(Icons.delete_outline),
                            tooltip: s.t("removeAccount"),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${s.t("userId")}: $userId"),
                const SizedBox(height: 8),
                Text("${s.t("savedCount")}: $savedAccountCount"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.t("language"),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButton<Locale>(
                  value: settings.locale,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: Locale("zh"),
                      child: Text("中文"),
                    ),
                    DropdownMenuItem(
                      value: Locale("en"),
                      child: Text("English"),
                    ),
                  ],
                  onChanged: (next) {
                    if (next != null) {
                      settings.setLocale(next);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  s.t("theme"),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButton<AppThemeMode>(
                  value: settings.themeMode,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: AppThemeMode.light,
                      child: Text(s.t("lightTheme")),
                    ),
                    DropdownMenuItem(
                      value: AppThemeMode.dark,
                      child: Text(s.t("darkTheme")),
                    ),
                    DropdownMenuItem(
                      value: AppThemeMode.pink,
                      child: Text(s.t("pinkTheme")),
                    ),
                  ],
                  onChanged: (next) {
                    if (next != null) {
                      settings.setTheme(next);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _logout,
          child: Text(s.t("logoutCurrent")),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.t("appTitle")),
          actions: [
            IconButton(
              onPressed: _loadConversations,
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              tooltip: s.t("backToLogin"),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: s.t("chats")),
              Tab(text: s.t("contacts")),
              Tab(text: s.t("me")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatsTab(),
            _buildContactsTab(),
            _buildMeTab(),
          ],
        ),
      ),
    );
  }
}

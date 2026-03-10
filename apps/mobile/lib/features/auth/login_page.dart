import "package:flutter/material.dart";

import "../../core/account_store.dart";
import "../../core/api_client.dart";
import "../../core/i18n/app_localizers.dart";
import "../../core/i18n/app_strings.dart";
import "../chat/chat_list_page.dart";
import "../relation/bind_page.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final accountCtrl = TextEditingController(text: "a@example.com");
  final passwordCtrl = TextEditingController(text: "12345678");
  final accountStore = AccountStore();
  String? error;
  bool loading = false;
  List<SavedAccount> savedAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadSavedAccounts();
  }

  Future<void> _loadSavedAccounts() async {
    final items = await accountStore.list();
    if (!mounted) return;
    setState(() => savedAccounts = items);
  }

  Future<void> _login() async {
    final s = AppStrings.of(context);
    setState(() {
      loading = true;
      error = null;
    });
    final result = await widget.apiClient.login(
      account: accountCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );
    if (!mounted) return;
    if (result["success"] == true) {
      final data = result["data"] as Map<String, dynamic>;
      final user = data["user"] as Map<String, dynamic>;
      final token = data["token"] as String? ?? "";
      await accountStore.upsert(
        userId: (user["id"] as String?) ?? "",
        account: (user["account"] as String?) ?? accountCtrl.text.trim(),
        nickname: (user["nickname"] as String?) ?? "",
        token: token,
      );
      await _loadSavedAccounts();
      await _routeByRelation();
    } else {
      setState(() {
        error = AppLocalizers.apiError(
          s,
          (result["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorUnknown",
        );
      });
    }
    setState(() => loading = false);
  }

  Future<void> _routeByRelation() async {
    final s = AppStrings.of(context);
    final relationResult = await widget.apiClient.currentRelation();
    if (!mounted) return;
    if (relationResult["success"] == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChatListPage(apiClient: widget.apiClient),
        ),
      );
      return;
    }
    final code = ((relationResult["error"] as Map?)?["code"] as String?) ?? "";
    if (code == "RELATION_404_NOT_BOUND") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BindPage(apiClient: widget.apiClient),
        ),
      );
      return;
    }
    setState(
      () => error = AppLocalizers.apiError(
        s,
        (relationResult["error"] as Map?)?.cast<String, dynamic>(),
        fallbackKey: "errorLoadRelationStateFailed",
      ),
    );
  }

  Future<void> _switchAccount(SavedAccount account) async {
    if (account.needsRelogin || account.token.isEmpty) {
      setState(() {
        accountCtrl.text = account.account;
        error = AppStrings.of(context).t("tokenExpiredPleaseLogin");
      });
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    widget.apiClient.setToken(account.token);
    final me = await widget.apiClient.me();
    if (!mounted) return;
    if (me["success"] == true) {
      await accountStore.touch(account.userId);
      await _loadSavedAccounts();
      await _routeByRelation();
      setState(() => loading = false);
      return;
    }
    await accountStore.markNeedsRelogin(account.userId);
    await _loadSavedAccounts();
    setState(() {
      loading = false;
      error =
          "${AppStrings.of(context).t("loginExpiredPrefix")}${account.account}${AppStrings.of(context).t("loginExpiredSuffix")}";
      accountCtrl.text = account.account;
    });
    widget.apiClient.clearToken();
  }

  Future<void> _removeAccount(String userId) async {
    await accountStore.remove(userId);
    await _loadSavedAccounts();
  }

  Future<void> _clearAccounts() async {
    await accountStore.clear();
    await _loadSavedAccounts();
  }

  String _formatLastUsed(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return "-";
    final hh = dt.hour.toString().padLeft(2, "0");
    final mm = dt.minute.toString().padLeft(2, "0");
    return "${dt.month}/${dt.day} $hh:$mm";
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.t("login"))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (savedAccounts.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    s.t("savedAccounts"),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: loading ? null : _clearAccounts,
                    child: Text(s.t("clearAll")),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...savedAccounts.map(
                (acc) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (acc.nickname.isNotEmpty ? acc.nickname : acc.account)
                            .substring(0, 1)
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(acc.nickname.isNotEmpty ? acc.nickname : acc.account),
                    subtitle: Text(
                      "${acc.account} · ${_formatLastUsed(acc.lastUsedAt)}"
                      "${acc.needsRelogin ? " · ${s.t("needLoginTag")}" : ""}",
                    ),
                    onTap: loading ? null : () => _switchAccount(acc),
                    trailing: IconButton(
                      onPressed: loading ? null : () => _removeAccount(acc.userId),
                      icon: const Icon(Icons.delete_outline),
                      tooltip: s.t("removeAccount"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
            ],
            TextField(
              controller: accountCtrl,
              decoration: InputDecoration(labelText: s.t("account")),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: s.t("password")),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _login,
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(s.t("login")),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}

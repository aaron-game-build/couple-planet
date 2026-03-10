import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../core/api_client.dart";
import "../../core/i18n/app_localizers.dart";
import "../../core/i18n/app_strings.dart";
import "../chat/chat_list_page.dart";
import "../auth/login_page.dart";

class BindPage extends StatefulWidget {
  const BindPage({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<BindPage> createState() => _BindPageState();
}

class _BindPageState extends State<BindPage> {
  final inviteCtrl = TextEditingController();
  String? myInviteCode;
  String? error;
  Map<String, dynamic>? currentRelation;
  bool loading = false;
  bool _bootstrapped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bootstrapped) return;
    _bootstrapped = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadRelationState();
      }
    });
  }

  Future<void> _loadRelationState() async {
    final s = AppStrings.of(context);
    setState(() {
      loading = true;
      error = null;
    });
    final relationResult = await widget.apiClient.currentRelation();
    if (!mounted) return;
    if (relationResult["success"] == true) {
      setState(() {
        currentRelation = ((relationResult["data"] as Map<String, dynamic>)["relation"] as Map<String, dynamic>?);
        loading = false;
      });
    } else {
      final code = ((relationResult["error"] as Map?)?["code"] as String?) ?? "";
      if (code == "RELATION_404_NOT_BOUND") {
        setState(() {
          currentRelation = null;
        });
        await _loadInviteCode(showToast: false);
        return;
      }
      setState(() {
        loading = false;
        error = AppLocalizers.apiError(
          s,
          (relationResult["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorLoadRelationFailed",
        );
      });
    }
  }

  Future<void> _loadInviteCode({bool showToast = false}) async {
    final s = AppStrings.of(context);
    final result = await widget.apiClient.createInviteCode();
    if (!mounted) return;
    if (result["success"] == true) {
      setState(() {
        myInviteCode = ((result["data"] as Map<String, dynamic>)["inviteCode"] as String?) ?? "";
        loading = false;
      });
      if (showToast) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.t("inviteRefreshed"))),
        );
      }
    } else {
      setState(() {
        loading = false;
        error = AppLocalizers.apiError(
          s,
          (result["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorUnknown",
        );
      });
    }
  }

  Future<void> _bind() async {
    final s = AppStrings.of(context);
    setState(() {
      loading = true;
      error = null;
    });
    final result = await widget.apiClient.bind(inviteCtrl.text.trim());
    if (!mounted) return;
    if (result["success"] == true) {
      await _loadRelationState();
    } else {
      setState(() {
        loading = false;
        error = AppLocalizers.apiError(
          s,
          (result["error"] as Map?)?.cast<String, dynamic>(),
          fallbackKey: "errorBindFailed",
        );
      });
    }
  }

  void _backToLogin() {
    widget.apiClient.token = null;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage(apiClient: widget.apiClient)),
      (_) => false,
    );
  }

  void _goChat() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ChatListPage(apiClient: widget.apiClient)),
    );
  }

  Future<void> _copyInviteCode() async {
    final code = (myInviteCode ?? "").trim();
    if (code.isEmpty || code == "...") return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    final s = AppStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.t("inviteCodeCopied"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final partner = (currentRelation?["partner"] as Map<String, dynamic>?);
    final isBound = currentRelation != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.t("bind")),
        actions: [
          IconButton(
            onPressed: loading ? null : _loadRelationState,
            icon: const Icon(Icons.sync),
            tooltip: s.t("refreshRelation"),
          ),
          IconButton(
            onPressed: _backToLogin,
            icon: const Icon(Icons.logout),
            tooltip: s.t("backToLogin"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBound) ...[
              Text(
                "${s.t("bound")}: ${(partner?["nickname"] as String?) ?? s.t("partner")}",
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _goChat, child: Text(s.t("goToChat"))),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Text("${s.t("myInviteCode")}: ${myInviteCode ?? "..."}"),
                  ),
                  IconButton(
                    onPressed: loading ? null : _copyInviteCode,
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    tooltip: s.t("copyInviteCode"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: loading ? null : () => _loadInviteCode(showToast: true),
                child: Text(s.t("generateInviteCode")),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: inviteCtrl,
                decoration: InputDecoration(labelText: s.t("partnerInviteCode")),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: loading ? null : _bind,
                child: Text(s.t("bind")),
              ),
            ],
            if (loading) ...[
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
            ],
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

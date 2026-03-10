import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

class ApiClient {
  ApiClient({
    String? baseUrl,
  }) : baseUrl = baseUrl ?? _resolveBaseUrl();

  final String baseUrl;
  String? token;

  void setToken(String? value) {
    token = value;
  }

  void clearToken() {
    token = null;
  }

  // Highest priority: --dart-define=API_BASE_URL=http://x.x.x.x:3000/api/v1
  static const String _envBaseUrl = String.fromEnvironment("API_BASE_URL");

  static String _resolveBaseUrl() {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    if (kIsWeb) {
      return "http://localhost:3000/api/v1";
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android emulator maps host machine localhost to 10.0.2.2
        return "http://10.0.2.2:3000/api/v1";
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return "http://localhost:3000/api/v1";
    }
  }

  Map<String, String> _headers({bool withAuth = false}) {
    final headers = <String, String>{
      "Content-Type": "application/json",
    };
    if (withAuth && token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  Future<Map<String, dynamic>> register({
    required String account,
    required String password,
    required String nickname,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: _headers(),
      body: jsonEncode({
        "account": account,
        "password": password,
        "nickname": nickname,
      }),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String account,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: _headers(),
      body: jsonEncode({
        "account": account,
        "password": password,
      }),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data["success"] == true) {
      token = (data["data"] as Map<String, dynamic>)["token"] as String?;
    }
    return data;
  }

  Future<Map<String, dynamic>> createInviteCode() async {
    final res = await http.post(
      Uri.parse("$baseUrl/relations/invite-code"),
      headers: _headers(withAuth: true),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> bind(String inviteCode) async {
    final res = await http.post(
      Uri.parse("$baseUrl/relations/bind"),
      headers: _headers(withAuth: true),
      body: jsonEncode({"inviteCode": inviteCode}),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> currentRelation() async {
    final res = await http.get(
      Uri.parse("$baseUrl/relations/current"),
      headers: _headers(withAuth: true),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> latestRelation() async {
    final res = await http.get(
      Uri.parse("$baseUrl/relations/latest"),
      headers: _headers(withAuth: true),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> unbindRelation() async {
    final res = await http.post(
      Uri.parse("$baseUrl/relations/unbind"),
      headers: _headers(withAuth: true),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> me() async {
    final res = await http.get(
      Uri.parse("$baseUrl/auth/me"),
      headers: _headers(withAuth: true),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchMessages({
    int limit = 20,
    bool includeArchived = false,
  }) async {
    final res = await http.get(
      Uri.parse(
        "$baseUrl/chats/current/messages?limit=$limit&includeArchived=${includeArchived ? "true" : "false"}",
      ),
      headers: _headers(withAuth: true),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendMessage({
    required String clientMsgId,
    required String content,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chats/current/messages"),
      headers: _headers(withAuth: true),
      body: jsonEncode({
        "clientMsgId": clientMsgId,
        "content": content,
      }),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> markMessagesRead({
    required List<String> messageIds,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/chats/current/messages/read"),
      headers: _headers(withAuth: true),
      body: jsonEncode({
        "messageIds": messageIds,
      }),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}

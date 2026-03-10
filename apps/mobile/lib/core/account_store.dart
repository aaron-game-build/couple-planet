import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter/services.dart";

class SavedAccount {
  SavedAccount({
    required this.userId,
    required this.account,
    required this.nickname,
    required this.token,
    required this.lastUsedAt,
    required this.needsRelogin,
  });

  final String userId;
  final String account;
  final String nickname;
  final String token;
  final String lastUsedAt;
  final bool needsRelogin;

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "account": account,
    "nickname": nickname,
    "token": token,
    "lastUsedAt": lastUsedAt,
    "needsRelogin": needsRelogin,
  };

  factory SavedAccount.fromJson(Map<String, dynamic> json) {
    return SavedAccount(
      userId: (json["userId"] as String?) ?? "",
      account: (json["account"] as String?) ?? "",
      nickname: (json["nickname"] as String?) ?? "",
      token: (json["token"] as String?) ?? "",
      lastUsedAt: (json["lastUsedAt"] as String?) ?? DateTime.now().toIso8601String(),
      needsRelogin: (json["needsRelogin"] as bool?) ?? false,
    );
  }
}

class AccountStore {
  AccountStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _storageKey = "saved_accounts_v1";
  final FlutterSecureStorage _storage;

  Future<List<SavedAccount>> list() async {
    try {
      final raw = await _safeRead(_storageKey);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw) as List<dynamic>;
      final items = decoded
          .map((item) => SavedAccount.fromJson(item as Map<String, dynamic>))
          .toList();
      items.sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
      return items;
    } on FormatException {
      return [];
    }
  }

  Future<void> upsert({
    required String userId,
    required String account,
    required String nickname,
    required String token,
  }) async {
    final items = await list();
    final now = DateTime.now().toIso8601String();
    final existingIdx = items.indexWhere((e) => e.userId == userId);
    final next = SavedAccount(
      userId: userId,
      account: account,
      nickname: nickname,
      token: token,
      lastUsedAt: now,
      needsRelogin: false,
    );
    if (existingIdx >= 0) {
      items[existingIdx] = next;
    } else {
      items.add(next);
    }
    await _save(items);
  }

  Future<void> touch(String userId) async {
    final items = await list();
    final idx = items.indexWhere((e) => e.userId == userId);
    if (idx < 0) return;
    final cur = items[idx];
    items[idx] = SavedAccount(
      userId: cur.userId,
      account: cur.account,
      nickname: cur.nickname,
      token: cur.token,
      lastUsedAt: DateTime.now().toIso8601String(),
      needsRelogin: cur.needsRelogin,
    );
    await _save(items);
  }

  Future<void> markNeedsRelogin(String userId) async {
    final items = await list();
    final idx = items.indexWhere((e) => e.userId == userId);
    if (idx < 0) return;
    final cur = items[idx];
    items[idx] = SavedAccount(
      userId: cur.userId,
      account: cur.account,
      nickname: cur.nickname,
      token: "",
      lastUsedAt: cur.lastUsedAt,
      needsRelogin: true,
    );
    await _save(items);
  }

  Future<void> remove(String userId) async {
    final items = await list();
    items.removeWhere((e) => e.userId == userId);
    await _save(items);
  }

  Future<void> clear() async {
    await _safeDelete(_storageKey);
  }

  Future<void> _save(List<SavedAccount> accounts) {
    final raw = jsonEncode(accounts.map((e) => e.toJson()).toList());
    return _safeWrite(_storageKey, raw);
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } on MissingPluginException {
      // Plugin might be unavailable after hot restart; fail soft.
      return null;
    } on PlatformException {
      // Plugin might be unavailable after hot restart; fail soft.
      return null;
    }
  }

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on MissingPluginException {
      // Ignore write when plugin is temporarily unavailable.
    } on PlatformException {
      // Ignore write when plugin is temporarily unavailable.
    }
  }

  Future<void> _safeDelete(String key) async {
    try {
      await _storage.delete(key: key);
    } on MissingPluginException {
      // Ignore delete when plugin is temporarily unavailable.
    } on PlatformException {
      // Ignore delete when plugin is temporarily unavailable.
    }
  }
}

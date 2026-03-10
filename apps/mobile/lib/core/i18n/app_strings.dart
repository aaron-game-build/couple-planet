import "package:flutter/widgets.dart";

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();

  static AppStrings of(BuildContext context) {
    final strings = Localizations.of<AppStrings>(context, AppStrings);
    assert(strings != null, "AppStrings not found in context");
    return strings!;
  }

  static const supportedLocales = [
    Locale("zh"),
    Locale("en"),
  ];

  static const _localizedValues = <String, Map<String, String>>{
    "zh": {
      "appTitle": "情侣星球",
      "login": "登录",
      "account": "账号",
      "password": "密码",
      "savedAccounts": "已保存账号",
      "noSavedAccounts": "暂无已保存账号",
      "currentAccount": "当前",
      "removeAccount": "移除账号",
      "clearAll": "清空",
      "bind": "绑定",
      "chat": "聊天",
      "send": "发送",
      "retry": "重试",
      "backToLogin": "返回登录",
      "typeMessage": "输入消息...",
      "chats": "聊天",
      "contacts": "联系人",
      "me": "我的",
      "openChat": "打开聊天",
      "refresh": "刷新",
      "goBind": "去绑定",
      "logoutCurrent": "退出当前账号",
      "switchAccount": "切换账号",
      "language": "语言",
      "theme": "主题",
      "savedCount": "已保存账号数",
      "userId": "用户ID",
      "partner": "伴侣",
      "bound": "已绑定",
      "historyReadOnly": "历史只读",
      "historyReadOnlyDesc": "这是历史会话，只能查看，暂不支持发送消息。",
      "status": "状态",
      "boundAt": "绑定时间",
      "relationStatusActive": "关系正常",
      "relationStatusUnbound": "已解绑",
      "relationStatusUnknown": "未知状态",
      "notBoundYet": "你们还未绑定关系",
      "archivedHistoryTitle": "历史关系已归档",
      "archivedHistoryDesc": "当前版本仅展示进行中的关系。若你们曾解绑，历史聊天将暂不在主聊天中显示。",
      "noConversations": "暂无会话",
      "noMessagesYet": "暂无消息",
      "noMessagesFirst": "暂无消息，快发送第一条吧",
      "partnerInviteCode": "伴侣邀请码",
      "myInviteCode": "我的邀请码",
      "generateInviteCode": "生成/刷新邀请码",
      "copyInviteCode": "复制邀请码",
      "inviteCodeCopied": "邀请码已复制",
      "inviteRefreshed": "邀请码已刷新，旧码已失效",
      "goToChat": "去聊天",
      "viewHistoryChat": "查看历史聊天",
      "refreshRelation": "刷新关系状态",
      "uiStates": "UI状态预览",
      "chatStatesTitle": "聊天页面状态",
      "chatStatesEmpty": "空状态：暂无消息",
      "chatStatesPeerSample": "这是一条对方消息示例",
      "chatStatesSelfSample": "这是一条我的消息示例",
      "duplicateRequestMerged": "重复请求已合并",
      "retrySend": "重试发送",
      "syncNow": "立即同步",
      "needLoginTag": "需重新登录",
      "tokenExpiredPleaseLogin": "登录态已失效，请重新登录。",
      "loginExpiredPrefix": "账号 ",
      "loginExpiredSuffix": " 登录已过期，请重新登录。",
      "pinToTop": "置顶",
      "unpin": "取消置顶",
      "muteNotifications": "消息免打扰",
      "unmute": "取消免打扰",
      "lightTheme": "浅色（白）",
      "darkTheme": "深色（黑）",
      "pinkTheme": "粉色",
      "errorUnknown": "发生未知错误",
      "errorLoadUserFailed": "加载用户失败",
      "errorLoadMessagesFailed": "加载消息失败",
      "errorSendFailed": "发送失败",
      "errorLoadConversationsFailed": "加载会话失败",
      "errorLoadRelationFailed": "加载关系失败",
      "errorLoadProfileFailed": "加载个人资料失败",
      "errorLoadRelationStateFailed": "加载关系状态失败",
      "errorBindFailed": "绑定失败",
      "errorUnbindFailed": "解绑失败",
      "errorAuthTokenInvalid": "登录凭证无效，请重新登录",
      "errorRebindMigrationRequired": "数据库迁移未完成，请先执行 rebind 迁移脚本",
      "unbindRelation": "解除绑定",
      "unbindConfirmTitle": "确认解除绑定？",
      "unbindConfirmDesc": "解绑后将回到绑定流程，当前关系会置为已解绑。",
      "cancel": "取消",
      "confirm": "确认",
      "contactsComingSoon": "联系人功能建设中",
      "profileComingSoon": "个人页功能建设中",
    },
    "en": {
      "appTitle": "Couple Planet",
      "login": "Login",
      "account": "Account",
      "password": "Password",
      "savedAccounts": "Saved Accounts",
      "noSavedAccounts": "No saved accounts",
      "currentAccount": "Current",
      "removeAccount": "Remove account",
      "clearAll": "Clear All",
      "bind": "Bind",
      "chat": "Chat",
      "send": "Send",
      "retry": "Retry",
      "backToLogin": "Back to Login",
      "typeMessage": "Type message...",
      "chats": "Chats",
      "contacts": "Contacts",
      "me": "Me",
      "openChat": "Open Chat",
      "refresh": "Refresh",
      "goBind": "Go Bind",
      "logoutCurrent": "Logout Current",
      "switchAccount": "Switch Account",
      "language": "Language",
      "theme": "Theme",
      "savedCount": "Saved accounts",
      "userId": "User ID",
      "partner": "Partner",
      "bound": "Bound",
      "historyReadOnly": "History (Read-only)",
      "historyReadOnlyDesc": "This is a historical chat. You can view messages but cannot send.",
      "status": "Status",
      "boundAt": "Bound at",
      "relationStatusActive": "Active",
      "relationStatusUnbound": "Unbound",
      "relationStatusUnknown": "Unknown",
      "notBoundYet": "You are not bound yet",
      "archivedHistoryTitle": "History is archived",
      "archivedHistoryDesc": "This version only shows active relations. If you unbound before, old chats are hidden from the main chat entry.",
      "noConversations": "No conversations yet",
      "noMessagesYet": "No messages yet",
      "noMessagesFirst": "No messages yet. Send the first one.",
      "partnerInviteCode": "Partner invite code",
      "myInviteCode": "My invite code",
      "generateInviteCode": "Generate / Refresh Invite Code",
      "copyInviteCode": "Copy Invite Code",
      "inviteCodeCopied": "Invite code copied",
      "inviteRefreshed": "Invite code refreshed. Previous codes are invalid now.",
      "goToChat": "Go to Chat",
      "viewHistoryChat": "View History Chat",
      "refreshRelation": "Refresh relation",
      "uiStates": "UI states",
      "chatStatesTitle": "Chat UI States",
      "chatStatesEmpty": "Empty: no messages yet",
      "chatStatesPeerSample": "This is a peer message sample.",
      "chatStatesSelfSample": "This is a self message sample.",
      "duplicateRequestMerged": "Duplicate request merged",
      "retrySend": "Retry send",
      "syncNow": "Sync now",
      "needLoginTag": "need login",
      "tokenExpiredPleaseLogin": "Token expired, please login again.",
      "loginExpiredPrefix": "Login expired for ",
      "loginExpiredSuffix": ". Please login again.",
      "pinToTop": "Pin to top",
      "unpin": "Unpin",
      "muteNotifications": "Mute notifications",
      "unmute": "Unmute",
      "lightTheme": "Light (White)",
      "darkTheme": "Dark (Black)",
      "pinkTheme": "Pink",
      "errorUnknown": "Unknown error",
      "errorLoadUserFailed": "Load user failed",
      "errorLoadMessagesFailed": "Load messages failed",
      "errorSendFailed": "Send failed",
      "errorLoadConversationsFailed": "Failed to load conversations",
      "errorLoadRelationFailed": "Failed to load relation",
      "errorLoadProfileFailed": "Failed to load profile",
      "errorLoadRelationStateFailed": "Failed to load relation state",
      "errorBindFailed": "Bind failed",
      "errorUnbindFailed": "Unbind failed",
      "errorAuthTokenInvalid": "Invalid token, please login again",
      "errorRebindMigrationRequired": "Database migration missing. Please apply rebind migration first.",
      "unbindRelation": "Unbind relation",
      "unbindConfirmTitle": "Confirm unbind?",
      "unbindConfirmDesc": "After unbinding, you will return to bind flow and relation becomes unbound.",
      "cancel": "Cancel",
      "confirm": "Confirm",
      "contactsComingSoon": "Contacts coming soon",
      "profileComingSoon": "Profile coming soon",
    },
  };

  String t(String key) {
    final lang = _localizedValues[locale.languageCode] ?? _localizedValues["en"]!;
    final value = lang[key];
    if (value != null) return value;
    assert(() {
      debugPrint("[i18n] missing key=\"$key\" for locale=\"${locale.languageCode}\"");
      return true;
    }());
    return _localizedValues["en"]?[key] ?? key;
  }

  @visibleForTesting
  static Map<String, Map<String, String>> allValuesForTest() {
    return _localizedValues;
  }
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.supportedLocales.any((e) => e.languageCode == locale.languageCode);
  }

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}

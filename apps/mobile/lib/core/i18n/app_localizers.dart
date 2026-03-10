import "app_strings.dart";

class AppLocalizers {
  static String relationStatus(AppStrings s, String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "active":
        return s.t("relationStatusActive");
      case "unbound":
      case "cancelled":
        return s.t("relationStatusUnbound");
      default:
        return s.t("relationStatusUnknown");
    }
  }

  static String apiError(
    AppStrings s,
    Map<String, dynamic>? error, {
    String fallbackKey = "errorUnknown",
  }) {
    final code = error?["code"] as String?;
    final key = _errorCodeToKey[code];
    if (key != null) {
      return s.t(key);
    }

    final message = (error?["message"] as String?)?.trim();
    if (message != null && message.isNotEmpty) {
      return message;
    }

    return s.t(fallbackKey);
  }

  static const Map<String, String> _errorCodeToKey = {
    "AUTH_401_TOKEN_INVALID": "errorAuthTokenInvalid",
    "RELATION_404_NOT_BOUND": "errorLoadRelationFailed",
    "RELATION_500_REBIND_MIGRATION_REQUIRED": "errorRebindMigrationRequired",
  };
}

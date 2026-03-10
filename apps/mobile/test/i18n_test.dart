import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:couple_planet_mobile/core/i18n/app_localizers.dart";
import "package:couple_planet_mobile/core/i18n/app_strings.dart";

void main() {
  test("i18n key sets are aligned between zh and en", () {
    final all = AppStrings.allValuesForTest();
    final zhKeys = all["zh"]!.keys.toSet();
    final enKeys = all["en"]!.keys.toSet();
    expect(zhKeys.difference(enKeys), isEmpty);
    expect(enKeys.difference(zhKeys), isEmpty);
  });

  test("relation status mapper handles known and unknown values", () {
    final zh = AppStrings(const Locale("zh"));
    expect(AppLocalizers.relationStatus(zh, "active"), equals(zh.t("relationStatusActive")));
    expect(AppLocalizers.relationStatus(zh, "unbound"), equals(zh.t("relationStatusUnbound")));
    expect(AppLocalizers.relationStatus(zh, "other"), equals(zh.t("relationStatusUnknown")));
  });

  test("api error mapper prioritizes code then message then fallback", () {
    final en = AppStrings(const Locale("en"));
    expect(
      AppLocalizers.apiError(en, {"code": "AUTH_401_TOKEN_INVALID"}),
      equals(en.t("errorAuthTokenInvalid")),
    );
    expect(
      AppLocalizers.apiError(en, {"message": "Server says no"}),
      equals("Server says no"),
    );
    expect(
      AppLocalizers.apiError(en, null, fallbackKey: "errorUnknown"),
      equals(en.t("errorUnknown")),
    );
  });
}

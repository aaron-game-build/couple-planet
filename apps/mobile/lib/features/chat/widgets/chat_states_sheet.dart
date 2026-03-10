import "package:flutter/material.dart";

import "../../../core/i18n/app_strings.dart";
import "../../../core/ui/ui_tokens.dart";
import "chat_bubble.dart";

class ChatStatesSheet extends StatelessWidget {
  const ChatStatesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(UiTokens.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.t("chatStatesTitle"),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: UiTokens.spacingMd),
            Text(
              s.t("chatStatesEmpty"),
              style: const TextStyle(color: UiTokens.subtleText),
            ),
            const SizedBox(height: UiTokens.spacingMd),
            ChatBubble(
              content: s.t("chatStatesPeerSample"),
              timeText: "10:30",
              isSelf: false,
              avatarLabel: "P",
            ),
            ChatBubble(
              content: s.t("chatStatesSelfSample"),
              timeText: "10:31",
              isSelf: true,
              avatarLabel: "M",
            ),
          ],
        ),
      ),
    );
  }
}

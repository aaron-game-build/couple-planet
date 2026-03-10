import "package:flutter/material.dart";

import "../../../core/ui/ui_tokens.dart";

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.content,
    required this.timeText,
    required this.isSelf,
    required this.avatarLabel,
    this.avatarBackgroundColor,
    this.avatarTextColor,
  });

  final String content;
  final String timeText;
  final bool isSelf;
  final String avatarLabel;
  final Color? avatarBackgroundColor;
  final Color? avatarTextColor;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isSelf ? UiTokens.selfBubble : UiTokens.peerBubble;
    final textColor = isSelf ? UiTokens.selfText : UiTokens.peerText;
    final rowChildren = <Widget>[
      _Avatar(
        label: avatarLabel,
        isSelf: isSelf,
        backgroundColor: avatarBackgroundColor,
        textColor: avatarTextColor,
      ),
      const SizedBox(width: UiTokens.spacingSm),
      Flexible(
        child: Column(
          crossAxisAlignment:
              isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: UiTokens.spacingMd,
                vertical: UiTokens.spacingSm,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(UiTokens.radiusMd),
              ),
              child: Text(
                content,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
            ),
            const SizedBox(height: UiTokens.spacingXs),
            Text(
              timeText,
              style: const TextStyle(
                fontSize: 11,
                color: UiTokens.subtleText,
              ),
            )
          ],
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UiTokens.spacingMd,
        vertical: UiTokens.spacingXs,
      ),
      child: Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isSelf ? rowChildren.reversed.toList() : rowChildren,
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.label,
    required this.isSelf,
    this.backgroundColor,
    this.textColor,
  });

  final String label;
  final bool isSelf;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: UiTokens.avatarSize / 2,
      backgroundColor: backgroundColor ??
          (isSelf ? UiTokens.selfBubble.withValues(alpha: 0.2) : Colors.white),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor ?? UiTokens.peerText,
        ),
      ),
    );
  }
}

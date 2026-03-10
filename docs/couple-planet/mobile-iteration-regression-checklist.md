# Mobile Iteration Regression Checklist

## Core Flow

- Login with saved account and fresh account.
- Route to bind page when relation is missing.
- Bind two accounts successfully and enter chat list.
- Open chat from Chats tab and from Contacts tab.
- Send message success path and failed retry path.
- Return to chat list and verify unread badge updates.

## Account Management (Me Tab)

- Saved accounts list renders correctly.
- Switch to another valid account in-place.
- Invalid/expired account prompts relogin flow.
- Remove saved account and verify list refresh.
- Logout current account and route to login.

## Relation Management

- Contacts tab shows partner card when bound.
- Unbind confirmation flow works and relation becomes unbound.
- After unbind, Contacts tab shows go-bind state.

## i18n and Theme

- Chinese and English switch reflects on main pages.
- Light, dark, pink theme switch works without restart.
- No hardcoded English appears in Chinese mode for primary flow.

## Engineering Guardrails

- Run `flutter analyze` and ensure no issues.
- Run `flutter test` and ensure all tests pass.
- Ensure new user-visible text uses `AppStrings`.

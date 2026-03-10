# Mobile Manual Regression Evidence (2026-03-10)
> Scope: iOS/Android manual verification handoff sheet

## Device Matrix

- iOS Device: TBD
- Android Device: TBD
- App Version: `0.1.0`
- Build Number: `1` (to be updated after TestFlight upload)

## Core Flow Capture

- [ ] Login with saved account and fresh account.
  - Evidence link: TBD
- [ ] Route to bind page when relation is missing.
  - Evidence link: TBD
- [ ] Open chat from Chats tab and from Contacts tab.
  - Evidence link: TBD
- [ ] Return to chat list and verify unread badge updates.
  - Evidence link: TBD

## Account Management Capture

- [ ] Saved accounts list renders correctly.
  - Evidence link: TBD
- [ ] Switch to another valid account in-place.
  - Evidence link: TBD
- [ ] Invalid/expired account prompts relogin flow.
  - Evidence link: TBD
- [ ] Remove saved account and verify list refresh.
  - Evidence link: TBD
- [ ] Logout current account and route to login.
  - Evidence link: TBD

## Relation and i18n Capture

- [ ] Contacts tab shows partner card when bound.
  - Evidence link: TBD
- [ ] Unbind confirmation flow works and relation becomes unbound.
  - Evidence link: TBD
- [ ] After unbind, Contacts tab shows go-bind state.
  - Evidence link: TBD
- [ ] Chinese and English switch reflects on main pages.
  - Evidence link: TBD
- [ ] Light, dark, pink theme switch works without restart.
  - Evidence link: TBD
- [ ] No hardcoded English appears in Chinese mode for primary flow.
  - Evidence link: TBD

## Engineering Guardrails

- [ ] `flutter analyze` PASS screenshot/log.
- [ ] `flutter test` PASS screenshot/log.
- [ ] New strings inspection (`AppStrings`) evidence.

## Execution Note

- This file is prepared in Linux environment as a manual execution handoff.
- Final status must be completed on macOS/Xcode and/or simulator-enabled host.

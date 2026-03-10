# TestFlight 上传执行记录（2026-03-10）
> EN: TestFlight Upload Execution Record

- Date: 2026-03-10
- Executor: openclaw session
- Target: `apps/mobile` iOS TestFlight upload

## 1）执行尝试

1. 校验本机上传工具链：
   - Command: `xcodebuild -version`
   - Output: `xcodebuild: command not found`
2. 结论：当前环境不具备 Xcode Organizer / Apple 签名链路，无法在本机会话完成真实 TestFlight 上传。

## 2）当前状态

- Status: BLOCKED（环境限制）
- Blocker:
  - 非 macOS 环境，缺少 Xcode。
  - Apple Developer / App Store Connect 上传权限需由发布负责人在发布机确认。

## 3）发布机执行清单（下一步）

1. 在 macOS 发布机执行：
   - `cd apps/mobile`
   - `flutter clean && flutter pub get`
   - `flutter build ios --release`
2. 打开 Xcode Organizer 完成 Archive 与 Upload。
3. 在 App Store Connect 创建 TestFlight 版本，填充发布说明：
   - `docs/release/testflight-release-notes-draft-v1.md`
4. 回填：
   - `docs/release/testflight-preupload-checklist-v1.md`
   - `docs/release/go-no-go-latest.md`

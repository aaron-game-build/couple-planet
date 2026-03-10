# iOS TestFlight 测试发布流程
> EN: iOS TestFlight Release Flow

本文定义 Couple Planet 从实现到 iOS 内测分发的标准路径。

建议配合发布机执行清单：
- `docs/release/testflight-macos-onepass-checklist.md`

## 1）前置条件

- Apple Developer 账号有效
- App Store Connect 已创建目标 App
- Bundle ID 固定且与工程配置一致
- 签名证书与 Provisioning Profile 可用

## 2）发布流水线

1. 在 Notion 冻结需求与验收标准
2. 在 Figma 冻结目标页面与状态
3. 完成实现与本地回归
4. 执行：
   - `flutter analyze`
   - `flutter test`
5. 生成 iOS Archive
6. 上传到 App Store Connect
7. 创建 TestFlight 内测版本与说明
8. 收集反馈并在 Notion 跟踪修复

## 3）构建命令（参考）

- 准备：
  - `cd apps/mobile`
  - `flutter clean && flutter pub get`
- 构建：
  - `flutter build ios --release`
- Archive/上传可通过 Xcode Organizer 或 CI 执行

## 4）发布说明最小要求

- 版本号与构建号
- 主要功能变化
- 风险与已知限制
- 测试账号与测试重点

## 5）TestFlight 轮次退出条件

- 无阻断级崩溃
- 核心流程通过：
  - 登录
  - 绑定/解绑
  - 聊天发送/历史只读
  - 账号切换
- 回归清单已完成并附证据

## 6）术语对照（Terminology）

- 前置条件：Pre-conditions
- 发布流水线：Release Pipeline
- 构建号：Build Number
- 发布说明：Release Notes
- 退出条件：Exit Criteria

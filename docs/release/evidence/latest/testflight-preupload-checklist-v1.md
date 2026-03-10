# TestFlight 上传前检查清单 v1
> EN: TestFlight Pre-upload Checklist v1

- Date: 2026-03-10
- Scope: First real pre-upload checklist

## 1）产品与设计（Product/Design）

- [x] 目标流程文档已冻结（`docs/couple-planet/ui-workflow.md`）
- [x] 文案与状态规则已定义（i18n + 状态覆盖）
- [ ] 本轮 Figma 目标页面已由产品最终确认（需人工确认）

## 2）工程质量（Engineering）

- [x] `flutter pub get` 通过  
  证据：`docs/release/testflight-dry-run-latest.md`
- [x] `flutter analyze` 通过  
  证据：`docs/release/testflight-dry-run-latest.md`
- [x] `flutter test` 通过  
  证据：`docs/release/testflight-dry-run-latest.md`
- [x] `flutter build ios --release --no-codesign` 通过  
  证据：`docs/release/testflight-dry-run-latest.md`
- [x] API 云上联调环境健康（`cloud-dev`）  
  当前状态：已通过（`bootstrap-cloud-dev.sh` + health check）  
  证据：`docs/operations/cloud-dev-execution-round-002.md`

## 3）回归与证据（Regression）

- [ ] `docs/couple-planet/week1-flow-regression-checklist.md` 全项勾选并附证据
  当前状态：后端主链路 + 邀请码跨重启持久化已补齐，移动端人工项待补
  证据：`docs/couple-planet/week1-flow-regression-evidence-2026-03-10.md`
- [ ] `docs/couple-planet/mobile-iteration-regression-checklist.md` 全项勾选并附证据
  当前状态：已补回归项结构与部分 API 证据，UI/账号切换项待真机执行
- [ ] 本轮缺陷清单已清空 P0/P1

## 4）iOS 交付前置（iOS Delivery）

- [ ] Apple Developer 账号状态确认  
  当前状态：待具备账号权限的发布人确认（本环境无法直接校验）
- [ ] App Store Connect App / Bundle ID / 签名配置确认  
  当前状态：待在 macOS 发布机执行
- [ ] Xcode Organizer 上传权限确认  
  当前状态：阻塞（当前环境 `xcodebuild: command not found`，需 macOS 发布机）
- [x] TestFlight 发布说明草稿完成  
  证据：`docs/release/testflight-release-notes-draft-v1.md`
- [ ] 内测名单与测试重点已通知

## 5）当前 Gate 结论

- Current Decision: **CONDITIONAL GO**
- 条件：
  1. 完成移动端人工回归证据补齐；
  2. 完成签名与上传相关人工步骤；
  3. 完成内测通知回填。

## 6）自动化补强（2026-03-10）

- 已新增最小 CI：
  - `.github/workflows/preupload-ci.yml`
  - 覆盖 API 构建 + iOS dry-run（analyze/test/build-no-codesign）
- 本地等价验证（2026-03-10）：
  - API build: PASS（`pnpm --filter @couple-planet/api build`）
  - iOS dry-run: FAIL（`flutter: command not found`，需 CI/macOS 环境）
- 已新增证据归档脚本：
  - `scripts/release/archive-preupload-evidence.sh`
  - 最新归档目录：运行归档脚本后回填

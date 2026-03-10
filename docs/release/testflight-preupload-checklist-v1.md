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
- [ ] API 云上联调环境健康（`cloud-dev`）  
  当前状态：阻塞（执行 `bootstrap-cloud-dev.sh` 时缺少 Docker）  
  证据：`docs/operations/cloud-dev-execution-round-001.md`

## 3）回归与证据（Regression）

- [ ] `docs/couple-planet/week1-flow-regression-checklist.md` 全项勾选并附证据
- [ ] `docs/couple-planet/mobile-iteration-regression-checklist.md` 全项勾选并附证据
- [ ] 本轮缺陷清单已清空 P0/P1

## 4）iOS 交付前置（iOS Delivery）

- [ ] Apple Developer 账号状态确认
- [ ] App Store Connect App / Bundle ID / 签名配置确认
- [ ] Xcode Organizer 上传权限确认
- [ ] TestFlight 发布说明草稿完成
- [ ] 内测名单与测试重点已通知

## 5）当前 Gate 结论

- Current Decision: **CONDITIONAL GO**
- 条件：
  1. 目标云主机安装 Docker 后完成 `cloud-dev` 拉起验证；
  2. 完成业务回归证据补齐；
  3. 完成签名与上传相关人工步骤。

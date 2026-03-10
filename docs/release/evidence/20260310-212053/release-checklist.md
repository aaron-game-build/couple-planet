# 发布检查清单
> EN: Release Checklist

## 产品与设计

- [ ] Notion 中的需求已验收
- [ ] Figma 目标页面已冻结
- [x] 文案与状态规则已最终确认

## 工程

- [x] API 与移动端代码已合并
- [x] 数据库迁移已评审并在目标环境执行
- [x] 环境变量已核对
- [x] `flutter analyze` 与 `flutter test` 已通过（见 dry-run 记录）
- [x] API 构建通过（`pnpm --filter @couple-planet/api build`）
- [x] cloud-dev 健康检查通过（见 `docs/operations/cloud-dev-execution-round-002.md`）

## 回归

- [ ] `docs/couple-planet/week1-flow-regression-checklist.md` 全项完成
- [ ] `docs/couple-planet/mobile-iteration-regression-checklist.md` 全项完成
- [x] 已补充后端主链路证据（`docs/couple-planet/week1-flow-regression-evidence-2026-03-10.md`）
- [ ] 证据已附在 Notion 的 `Release & Regression`

## iOS 交付

- [ ] 构建号已更新
- [ ] Archive 已生成并上传
- [x] TestFlight 发布说明已准备（`docs/release/testflight-release-notes-draft-v1.md`）
- [ ] 已通知内测成员并给出重点用例
- [ ] 发布机上传执行完成（见 `docs/release/testflight-upload-execution-2026-03-10.md`）

## 英文分组映射（Section Mapping）

- 产品与设计：Product and Design
- 工程：Engineering
- 回归：Regression
- iOS 交付：iOS Delivery

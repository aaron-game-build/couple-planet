# 发布检查清单
> EN: Release Checklist

## 产品与设计

- Notion 中的需求已验收
- Figma 目标页面已冻结
- 文案与状态规则已最终确认

## 工程

- API 与移动端代码已合并
- 数据库迁移已评审并在目标环境执行
- 环境变量已核对
- `flutter analyze` 与 `flutter test` 已通过
- API 构建通过（`pnpm --filter @couple-planet/api build`）

## 回归

- `docs/couple-planet/week1-flow-regression-checklist.md` 已完成
- `docs/couple-planet/mobile-iteration-regression-checklist.md` 已完成
- 证据已附在 Notion 的 `Release & Regression`

## iOS 交付

- 构建号已更新
- Archive 已生成并上传
- TestFlight 发布说明已准备
- 已通知内测成员并给出重点用例

## 英文分组映射（Section Mapping）

- 产品与设计：Product and Design
- 工程：Engineering
- 回归：Regression
- iOS 交付：iOS Delivery

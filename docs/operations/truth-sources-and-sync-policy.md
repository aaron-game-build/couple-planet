# 真源定义与同步策略
> EN: Truth Sources and Sync Policy

## 1）四层真源

- 产品真源：Notion
- 设计真源：Figma
- 架构真源：仓库内 `docs/architecture/` 图源文档
- 实现真源：
  - 后端：`apps/api/src/`
  - 移动端接口集成：`apps/mobile/lib/core/api_client.dart`

## 2）同步规则

- 任何 PRD 更新必须同时关联：
  - Figma 页面链接
  - 受影响的架构文档链接
  - 对应实现任务链接
- 任何架构变更必须先更新仓库图源，再更新外部评审板截图/卡片。
- 任何发布候选必须包含：
  - 回归结果
  - 版本说明
  - 已知风险说明

## 3）冲突处理优先级

若信息冲突，按以下优先级判定：

1. 实现真源
2. 架构真源
3. 设计真源
4. 产品真源

并在 Notion 立刻创建同步修复任务进行对齐。

## 4）术语对照（Terminology）

- 真源：Source of Truth
- 同步规则：Sync Rules
- 冲突处理优先级：Conflict Resolution Order

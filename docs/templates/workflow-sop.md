# 工作流 SOP（外部工具 + AI + 工程）
> EN: Workflow SOP (External Tools + AI + Engineering)

本 SOP 定义从需求到发布的端到端流程。

## 步骤 0：需求接入

- 在 Notion 创建 PRD 卡片
- 明确目标、范围、约束与验收标准

## 步骤 1：设计

- 在 Stitch 生成候选方案
- 在 Figma 确认最终稿并补齐状态
- 将 Figma 页面回链到 Notion

## 步骤 2：架构

- 更新仓库内 `docs/architecture/` 图源
- 从图源同步到外部评审板（draw.io/Miro）
- 重大决策写入 `Architecture Decisions`

## 步骤 3：实现

- 创建带验收标准的 `Dev Task`
- 在 API/移动端实施开发
- 变更过程遵循真源与同步规则

## 步骤 4：验证

- 执行静态检查与测试
- 执行回归清单
- 将证据附到 Notion 发布卡片

## 步骤 5：发布

- 按 `docs/release/ios-testflight-flow.md` 执行
- 完成 `docs/release/release-checklist.md`
- 发布 TestFlight 并收集反馈

## 步骤 6：复盘与模板迭代

- 复盘问题与有效实践
- 更新 SOP/模板/图源，减少重复错误

## 周内执行节奏（固定 Ritual）

### 周一：Scope Freeze

- 输入：`PRD / Requirements` 候选需求、上周遗留阻塞项
- 动作：冻结本周需求范围，确认 Stitch 发散目标
- 输出：本周 Top 1-3 需求清单 + 对应责任人

### 周二：Design Freeze

- 输入：Stitch 候选与关键旅程
- 动作：完成 Figma 最终稿与状态覆盖检查
- 输出：可实现的 Figma Frame URL/ID 与交互说明

### 周三：Architecture Sync

- 输入：Figma 冻结稿、评审意见
- 动作：更新仓库图源并同步到 draw.io/Miro
- 输出：`docs/architecture/*` 图源变更 + 决策记录

### 周四：Build & Integrate

- 输入：通过 Gate B 的 Dev Tasks
- 动作：完成移动端/后端纵向切片实现与联调
- 输出：可运行版本、问题清单、待修复项优先级

### 周五：Regression & Go/No-Go

- 输入：本周实现切片、回归清单
- 动作：执行回归、整理证据、给出 Go/No-Go
- 输出：`Release & Regression` 更新 + 证据链接

## 复盘回路（每周五 30 分钟）

- 回答三个问题：
  1. 哪个阶段最早出现偏差？
  2. 哪个门禁最有效防止返工？
  3. 下周要升级为硬约束的 1 条规则是什么？
- 将答案沉淀到：
  - `Architecture Decisions`（若涉及架构）
  - `docs/couple-planet/ui-workflow.md`（若涉及门禁/流程）
  - `docs/templates/notion-databases-and-views.md`（若涉及字段/视图）

## AI 集成规则

- AI 输出必须沉淀到以下至少一类资产：
  - Notion 需求/决策/任务
  - Figma 设计产物
  - 仓库文档/图源
  - 代码变更
  - 发布/回归记录
- 关键决策不得仅保留在聊天记录中

## 术语对照（Terminology）

- 需求接入：Intake
- 设计收敛：Design Convergence
- 架构沉淀：Architecture Documentation
- 实现执行：Implementation
- 验证：Validation
- 发布：Release
- 复盘：Retrospective

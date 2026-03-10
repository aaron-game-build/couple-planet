# 工作流 SOP（外部工具 + AI + 工程）
> EN: Workflow SOP (External Tools + AI + Engineering)

本 SOP 定义从需求到发布的端到端流程。

## 步骤 0：需求接入

- 在 Notion 创建 PRD 卡片
- 明确目标、范围、约束与验收标准

## 步骤 1：设计

- 在 Galileo 生成候选方案
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

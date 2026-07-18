# UI 工作流（Figma + Stitch + Notion + 仓库文档）
> EN: UI Workflow (Figma + Stitch + Notion + Repo Docs)

本文定义 Couple Planet 的默认外部协同流程。

## 1）四层真源

为避免外部工具与实现脱节，项目采用固定真源模型：

- 产品真源：Notion（`PRD / Requirements`、`Architecture Decisions`、`Dev Tasks`）
- 设计真源：Figma（`00_Foundation`、`01_Flows`、`02_Components`）
- 架构真源：仓库内 `docs/architecture/` 图源
- 实现真源：
  - 后端：`apps/api/src/`
  - 移动端接口契约：`apps/mobile/lib/core/api_client.dart`

## 2）工具角色

- Notion：需求、决策、研发任务、发布与回归记录
- Stitch：在定稿前做快速概念发散与原型草图生成
- Figma：实现前的页面/组件最终稿
- draw.io/Miro：外部架构评审与沟通看板
- 仓库中的 Mermaid/PlantUML：可版本化的系统图与类图
- Cursor + Flutter/NestJS：开发与验证执行

## 3）标准交付流程

1. 在 Notion 创建需求（`PRD / Requirements`）
2. 在 Stitch 生成 2-3 个候选方案
3. 在 Figma 收敛最终设计
4. 将架构影响更新到仓库图源（`docs/architecture/*`）
5. 在 Notion 创建实现任务（`Dev Tasks`）并写明验收项
6. 在代码仓库实现（`apps/mobile`、`apps/api`）
7. 执行回归并将证据回填 Notion（`Release & Regression`）

## 4）编码前输入包（必须完整）

实现前必须提供以下内容：

- Notion 需求链接与验收标准
- Figma 链接与目标 Frame ID
- 关键状态截图：default/loading/empty/error/readOnly
- 交互说明（点击流、禁用态、重试机制）
- 文案与边界规则（长度限制、兜底文案）
- 架构图引用（Mermaid/PlantUML 图源路径）

任一项缺失则任务保持在 `Design Pending`。

## 5）命名与结构规范

- Figma 页面命名：
  - `00_Foundation`
  - `01_Flows`
  - `02_Components`
- Frame 命名：
  - `Feature_Screen_State`（示例：`Chat_Main_Default`）
- Notion 任务标题：
  - `[Feature] goal`
  - 示例：`[Chat] LeftRightBubbleAndAvatar`

## 6）文档同步规则

- 任何 Notion PRD 变更必须关联：
  - 对应 Figma Frame
  - 受影响架构图
  - 对应实现任务
- 任何架构变更必须先更新仓库图源，再同步外部评审板
- 任何发布候选必须包含：
  - 回归清单结果
  - App 版本说明
  - API 行为变更说明（如有）

## 6.5）执行门禁（Input Package + Regression Evidence）

为避免“任务状态已完成，但证据不完整”，统一使用三段门禁：

### Gate A：Design Pending（默认态）

触发条件（任意一条满足即保持 `Design Pending`）：

- Notion 需求未附 `Figma Frame URL/ID`
- 缺少关键状态截图（default/loading/empty/error/readOnly）
- 缺少交互说明（点击流、禁用态、重试）
- 缺少架构图路径（`docs/architecture/*`）

通过条件：

- 第 4 节“编码前输入包”全部齐全。

### Gate B：Ready To Build

触发条件（全部满足）：

- `PRD / Requirements` 与 `Dev Tasks` 已双向关联
- Dev Task 已绑定验收清单（Acceptance Checklist）
- API 契约引用已明确（文档链接或路径）
- 对应架构图源已更新并可在仓库 diff

失败处理：

- 任一项缺失，`Dev Task` 状态回退为 `Blocked`，并在任务评论写明缺失项。

### Gate C：Ready To Release

触发条件（全部满足）：

- `flutter analyze` 无问题
- 关键回归清单全部执行完
- `Release & Regression` 已填写 `Go/No-Go`、缺陷摘要、证据链接
- 证据可追溯到具体需求与任务

失败处理：

- 若证据缺失或不可复现，发布结论只能为 `No-Go`。

## 7）完成定义（UI 与流程任务）

任务仅在以下条件都满足时视为完成：

- 视觉层级与 Figma 一致（布局、间距、字体、颜色）
- 关键状态已实现（default/loading/empty/error/readOnly）
- 复用共享 token/组件（避免无必要硬编码样式）
- `flutter analyze` 无问题
- 相关回归用例已在以下文档打勾：
  - `docs/couple-planet/week1-flow-regression-checklist.md`
  - `docs/couple-planet/mobile-iteration-regression-checklist.md`
- 已满足 Gate C（Ready To Release）全部条件

## 8）每周运转节奏

- 周一：冻结本周 Figma 目标与验收标准
- 每日：更新 Notion 任务状态并附实现截图
- 周五：执行回归清单并记录通过/失败及证据

### 每周固定检查（Ritual）

- 周一（计划会）：确认本周需求是否都通过 Gate A
- 周三（中期同步）：清理 `Blocked`，重点处理未通过 Gate B 的任务
- 周五（发布评审）：逐条检查 Gate C，并更新 `Release & Regression`

## 9）术语对照（Terminology）

- 四层真源：Four Truth Sources
- 标准交付流程：Standard Delivery Pipeline
- 编码前输入包：Required Input Package Before Coding
- 完成定义：Definition of Done
- 每周运转节奏：Weekly Operating Rhythm

# AI 参与下的产品与研发反思（Couple Planet）

## 1. 背景与目的

本文记录一次关键反思：在 AI 深度参与概念生成、需求拆解、数据库设计、代码实现与 review 的情况下，为什么项目仍出现后端逻辑 bug、多处需求漏覆盖、用户体验不佳的问题。

目标不是否定 AI，而是建立一套可重复执行的约束机制，把“看起来合理”升级为“可验证地正确”。

## 2. 判断结论

原判断基本正确：当前流程中确实存在“文档完整感高于真实可用性”的风险。

更准确地说，问题不在于有无文档、设计或代码，而在于这些产物很多仍停留在描述层，尚未被系统化地转换为状态机、不变量、门禁与可执行证据。

## 3. 现有仓库佐证

### 3.1 PRD 范围与当前实现之间有断层

- PRD 包含马车信封、星球页、解绑冷静期与封存导出等范围：`docs/couple-planet/mvp-prd-v1.md`
- 当前工程主链路仍主要是登录、绑定、聊天最小闭环：`README.md`、`apps/mobile/lib/main.dart`、`apps/api/src/modules/*`

这说明项目处于“先打通最小链路”的阶段，但如果继续以“PRD 已覆盖”为心理锚点，容易产生范围完成错觉。

### 3.2 关键业务语义尚未完全落地

- 解绑策略在 PRD 中定义为 72h 冷静期、可撤销、封存与导出：`docs/couple-planet/mvp-prd-v1.md`
- 当前后端 `unbind` 逻辑是直接更新关系状态为 `cancelled`：`apps/api/src/modules/relation/relation.service.ts`

这类差异不是一般缺陷，而是业务状态机尚未完备的信号。

### 3.3 文档预期与实现行为发生漂移

- 回归证据明确记录了“邀请码复用预期”和“邀请码刷新实现”存在差异：`docs/couple-planet/week1-flow-regression-evidence-2026-03-10.md`
- 同步后的回归清单改为验证“刷新逻辑”，并要求额外迁移：`docs/couple-planet/week1-flow-regression-checklist.md`

结论：当前流程有“实现驱动需求修订”的情况，需要更强的冻结与变更门禁。

### 3.4 测试证据对核心后端覆盖仍偏薄

- `apps/api` 有测试脚本定义（`jest`），但当前仓库中后端核心业务自动化测试较少：`apps/api/package.json`
- 已有证据以回归脚本与人工执行为主：`docs/couple-planet/week1-api-verification.md`、`docs/couple-planet/week1-day6-day7-acceptance.md`

这会导致“流程看起来完整”，但缺乏对边界行为和并发行为的稳定保护。

### 3.5 团队已定义方法论，但执行门禁尚不硬

- UI 工作流已经明确提出“编码前输入包必须完整”：`docs/couple-planet/ui-workflow.md`
- 现实清单里仍有部分移动端人工验收项待补：`docs/couple-planet/week1-flow-regression-checklist.md`

结论：问题更多是“执行门禁不足”，不是“方法论缺失”。

## 4. 为什么会这样

## 4.1 AI 输出与工程真实之间的天然差异

AI 擅长生成高质量文本和结构化方案，但不天然保证业务正确性。若没有后续约束，AI 产物会放大“合理性错觉”。

## 4.2 描述性资产未转换为可执行约束

需求、设计、数据库、review 只有在落入以下载体后才具备约束力：

- 数据库约束（唯一键、检查约束、外键）
- 状态机与转换规则
- API 契约与错误码
- 自动化测试与回归清单
- 发布门禁与证据

## 4.3 模块化推进掩盖了用户旅程断裂

按“模块完成”推进（登录模块、关系模块、聊天模块）容易造成局部可用但全链路体验断裂。用户感知的是“端到端旅程”，不是模块目录结构。

## 4.4 数据库过早字段化，过晚语义化

如果先定字段再定状态机和不变量，后续会出现“表结构看似完整，但业务语义靠代码补丁维持”的问题。

## 4.5 验证反馈回路不够短

没有将高频验证前置到每个迭代切片，就容易把问题推迟到联调或回归阶段集中爆发。

## 5. 从原理上规避同类问题

## 5.1 先定义不变量，再做数据与接口

示例（关系域）：

- 同一用户同一时刻最多一个 `active` 关系
- 邀请码刷新是否立即使旧码失效
- 冷静期内哪些动作被禁止
- 取消/生效/封存/导出的状态转换条件

## 5.2 先定义状态机，再做 UI 与实现

建议优先冻结域状态机：

- `Relation`
- `Invite`
- `Message`
- `Unbind`
- `Archive`

状态机冻结后，再映射 UI 状态、API 行为、DB 约束与测试用例。

## 5.3 每条需求必须“可证伪”

把“支持某功能”改写为可验证语句，例如：

- 输入条件
- 触发动作
- 期望状态
- 错误码/失败行为
- 恢复策略

## 5.4 把门禁嵌入流程而不是依赖记忆

必须通过门禁后才进入下一阶段，例如：

- 设计输入包不完整则不进入开发
- 契约未冻结不进入实现
- 回归证据不完整不允许 Go

## 5.5 明确 AI 的角色边界

- AI 负责：提案、对照、补漏、挑战假设
- 人负责：业务裁决、范围取舍、风险优先级、Go/No-Go

## 6. 对 Owner 的实践建议

## 6.1 流程层

- 用 3-5 条关键用户旅程替代“大而全需求清单”
- 每次只实现一条纵向链路（产品、设计、API、DB、前后端、测试一起闭环）
- 用发布门禁替代“口头确认完成”

## 6.2 知识补强层

优先补齐以下能力：

- 需求建模（JTBD、Story Mapping、验收标准写法）
- UI/UX 状态设计（default/loading/empty/error/readOnly/retry）
- 领域建模（状态机、不变量、幂等、事务边界）
- 测试策略（契约测试、集成测试、回归分层）

## 6.3 工具层

- 需求与任务：Notion（见 `docs/templates/notion-databases-and-views.md`）
- 设计与状态：Figma（见 `docs/couple-planet/figma-bootstrap-pack.md`）
- 流程总纲：`docs/templates/workflow-sop.md`
- 项目流程：`docs/couple-planet/ui-workflow.md`
- 验证与发布：`docs/couple-planet/week1-day6-day7-acceptance.md`、`docs/release/release-checklist.md`

## 7. 后续执行要求（建议）

每个新功能在进入开发前，至少回答以下问题：

1. 关键用户旅程是什么，成功与失败分别如何恢复？
2. 业务状态机是什么，是否覆盖异常分支？
3. 核心不变量是什么，由谁在何处保证？
4. API 契约是否冻结，错误码是否可追溯？
5. 测试矩阵是否覆盖 happy path、edge case、failure recovery？

若任一问题无法回答，任务应停留在设计或建模阶段，而非直接编码。

## 8. 相关文档

- `docs/couple-planet/mvp-prd-v1.md`
- `docs/couple-planet/ui-workflow.md`
- `docs/couple-planet/week1-ddl.sql`
- `docs/couple-planet/week1-api-contract.md`
- `docs/couple-planet/week1-api-verification.md`
- `docs/couple-planet/week1-day6-day7-acceptance.md`
- `docs/couple-planet/week1-flow-regression-checklist.md`
- `docs/couple-planet/week1-flow-regression-evidence-2026-03-10.md`
- `apps/api/src/modules/relation/relation.service.ts`
- `apps/mobile/lib/main.dart`

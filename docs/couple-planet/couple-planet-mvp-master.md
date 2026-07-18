# Couple Planet 首个产品 MVP 总览（Master）

## 1. 文档目标

本主文档用于提供首个产品 MVP 的单点入口，统一查看以下内容：

- 产品目标与范围
- 关键体验闭环
- 交付节奏与门禁
- 配套资料索引（Notion/Stitch、架构与数据、测试与发布）

## 2. MVP 目标与北极星

来源：`docs/couple-planet/mvp-prd-v1.md`

- 目标用户：18-30 岁情侣用户（优先异地恋）
- 核心主张：
  - 即时沟通不受阻
  - 高价值内容通过等待放大情绪价值
  - 互动沉淀为可见的星球成长
- 北极星指标：首周马车信封渗透率（每对绑定关系至少发送 1 封）

## 3. MVP 范围（冻结）

### In Scope

1. 账号与双人绑定
2. 即时消息（文本/表情/已读）
3. 马车信封（文本/语音/单图、ETA、途中事件、到达提醒）
4. 星球主页（状态展示、轻交互、能量与星屑反馈）
5. 解绑流程（72h 冷静期、撤销、封存、导出）

### Out of Scope

- 3D 房间与家具系统
- 复杂星球建造编辑器
- 秒级实时轨迹追踪
- 社区/UGC

## 4. 四条核心体验闭环

## 4.1 绑定闭环

注册 -> 登录 -> 生成邀请码 -> 绑定 -> 查询当前关系

## 4.2 即时沟通闭环

进入会话 -> 发消息 -> 拉历史 -> 标已读 -> 弱网重试

## 4.3 马车信封闭环

创建信封 -> 在途展示 -> 到达提醒 -> 开启 -> 奖励回流（能量/星屑）

## 4.4 关系收口闭环

发起解绑 -> 冷静期倒计时 -> 可撤销 -> 生效 -> 封存/导出/删除

## 5. 交付节奏（6-8 周）

来源：`docs/couple-planet/mvp-prd-v1.md`、`docs/couple-planet/mvp-delivery-backlog-v1.md`

- Sprint1（Week1-2）：账号、绑定、即时消息基础链路
- Sprint2（Week3-4）：马车信封、ETA、旅程状态同步
- Sprint3（Week5-6）：星球状态机、轻交互、能量流水
- Sprint4（Week7-8）：解绑冷静期、封存导出、埋点与灰度上线

## 6. 协作工具接入（Stitch 版）

来源：`docs/couple-planet/ui-workflow.md`

- Notion：需求、决策、任务、发布与证据
- Stitch：定稿前快速概念发散与原型草图
- Figma：实现前最终页面与组件稿
- draw.io/Miro：外部架构评审看板
- Mermaid/PlantUML：仓库内可版本化架构图源
- Cursor + Flutter/NestJS：实现与验证

## 7. 交付门禁（必须）

来源：`docs/couple-planet/ui-workflow.md`

- Gate A（Design Pending）：输入包不完整不得进入开发
- Gate B（Ready To Build）：需求/任务/契约/图源未联动不得开工
- Gate C（Ready To Release）：分析与回归证据不完整不得 Go

## 8. 配套文档索引（同目录）

1. Notion 与 Stitch 资料包：`docs/couple-planet/couple-planet-mvp-notion-and-stitch-pack.md`
2. 架构与数据资料包：`docs/couple-planet/couple-planet-mvp-architecture-and-data-pack.md`
3. 测试与发布资料包：`docs/couple-planet/couple-planet-mvp-test-and-release-pack.md`

## 9. 关联真源索引

- 产品总纲：`docs/couple-planet/mvp-prd-v1.md`
- 交付拆解：`docs/couple-planet/mvp-delivery-backlog-v1.md`
- Sprint 执行包：
  - `docs/couple-planet/sprint1-execution-pack-week1-2.md`
  - `docs/couple-planet/sprint2-execution-pack-week3-4.md`
  - `docs/couple-planet/sprint3-execution-pack-week5-6.md`
  - `docs/couple-planet/sprint4-execution-pack-week7-8.md`
- 架构图源：
  - `docs/architecture/system-context.mmd`
  - `docs/architecture/mobile-backend-modules.puml`
- API 与验证：
  - `docs/couple-planet/week1-api-contract.md`
  - `docs/couple-planet/week1-api-verification.md`
  - `docs/couple-planet/week1-day6-day7-acceptance.md`
  - `docs/couple-planet/week1-flow-regression-checklist.md`

## 10. 口径一致性检查结果（本轮）

## 10.1 工具口径

- 已完成 `Galileo -> Stitch` 全量替换（流程、字段、样板文档）
- 综合资料包统一使用 `Stitch` 作为概念发散工具名

## 10.2 需求与契约差异（需后续冻结）

1. 即时消息文字上限不一致
   - 业务边界文档：`<=300`（`communication-boundary-spec.md`）
   - Week1 API 契约：`1-1000`（`week1-api-contract.md`）
   - 建议：在下一版契约冻结时统一并在前后端同时收敛

2. 健康检查接口口径不一致
   - 回归清单使用：`/api/v1/health`
   - Week1 契约未列该接口
   - 建议：将健康检查加入 API 契约“内部/运维接口”章节

3. 邀请码刷新规则文档存在历史描述差异
   - 回归清单与当前实现：再次生成邀请码会刷新（旧码失效）
   - 证据文档存在旧预期说明
   - 建议：以当前实现为准，统一修订历史描述

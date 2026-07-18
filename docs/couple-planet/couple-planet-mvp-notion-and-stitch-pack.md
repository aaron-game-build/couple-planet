# Couple Planet MVP Notion + Stitch 资料包

## 1. 目的

本文件提供首个产品 MVP 的协作输入资产：

- Notion 需要创建的全部卡片与字段模板
- 各阶段可直接复制的内容样板
- Stitch 生成提示词（Prompt）模板
- Stitch 输出落地到 Figma / Notion / 仓库文档的规范

## 2. Notion 数据库与字段（执行版）

数据库沿用：`PRD / Requirements`、`Architecture Decisions`、`Dev Tasks`、`Release & Regression`。

## 2.1 PRD / Requirements 必填字段

- `Title / 标题`
- `Status / 状态`
- `Priority / 优先级`
- `Acceptance Criteria / 验收标准`
- `Stitch Options Link / Stitch 候选链接`
- `Figma Frame URL / Figma 页面链接`
- `Figma Frame ID / Figma 页面ID`
- `Architecture Decision Link / 架构决策链接`
- `Architecture Diagram Path / 架构图路径`
- `Related Dev Tasks / 关联开发任务`
- `Input Package Ready / 输入包完整`

## 2.2 Architecture Decisions 必填字段

- `Decision ID / 决策编号`
- `Title / 标题`
- `Context / 背景`
- `Decision / 决策`
- `Consequences / 影响`
- `Diagram Source Path / 图源路径`
- `Related PRD / 关联需求`

## 2.3 Dev Tasks 必填字段

- `Task Title / 任务标题`
- `Module / 模块`
- `Requirement Link / 需求链接`
- `API Contract Link / API 契约链接`
- `Architecture Diagram Path / 架构图路径`
- `Acceptance Checklist / 验收清单`
- `Regression Evidence Link / 回归证据链接`
- `Gate Result / 门禁结果`
- `Status / 状态`
- `Owner / 负责人`

## 2.4 Release & Regression 必填字段

- `Version / 版本`
- `Build Version / 构建版本`
- `Go No-Go / 发布结论`
- `P0 P1 Summary / 缺陷摘要`
- `Evidence Bundle / 证据包`
- `Linked Dev Tasks / 关联研发任务`

## 3. 首个 MVP 的 Notion 生成内容清单

## 3.1 PRD / Requirements（建议 4 条主卡）

1. `[MVP] AccountAndBindingCore`
   - 范围：注册/登录/绑定/关系查询
2. `[MVP] InstantChatCore`
   - 范围：发送/拉取/已读/重试
3. `[MVP] CarriageEnvelopeCore`
   - 范围：创建/在途/到达/开启/加急
4. `[MVP] PlanetAndUnbindClosure`
   - 范围：星球状态、能量流水、解绑封存导出

每条卡片均需补齐六链：

1. `Stitch Options Link`
2. `Figma Frame URL`
3. `Figma Frame ID`
4. `Architecture Decision Link`
5. `Architecture Diagram Path`
6. `Regression Evidence Link`（开发后补）

## 3.2 Architecture Decisions（建议 8 条）

- `ADR-001` 双通道通讯边界
- `ADR-002` 邀请码与绑定唯一性策略
- `ADR-003` 即时消息幂等键与重试策略
- `ADR-004` 马车信封状态机与异常分支
- `ADR-005` ETA 降级策略（地图异常）
- `ADR-006` 星球状态机与能量账本规则
- `ADR-007` 解绑冷静期与封存导出策略
- `ADR-008` 发布门禁与证据归档策略

## 3.3 Dev Tasks（建议按 Sprint 建立）

来源映射：`docs/couple-planet/mvp-delivery-backlog-v1.md`

- Sprint1（Week1-2）：FE-01/02/03 + BE-01/02
- Sprint2（Week3-4）：FE-04/05 + BE-03/04
- Sprint3（Week5-6）：FE-06/07 + BE-05
- Sprint4（Week7-8）：FE-08/09/10 + BE-06/07/08 + QA-03/04

每条 Dev Task 最少绑定：

- 1 条 PRD
- 1 个 API 契约链接
- 1 个图源路径
- 1 份验收清单

## 3.4 Release & Regression（建议 4 条）

- `MVP-S1-Week2-ReleaseCandidate`
- `MVP-S2-Week4-ReleaseCandidate`
- `MVP-S3-Week6-ReleaseCandidate`
- `MVP-S4-Week8-GoNoGo`

## 4. Stitch 提示词模板（可直接复制）

说明：以下 Prompt 输出为“候选方案”，不是最终稿。定稿必须进入 Figma 并绑定 Frame ID。

## 4.0 全局设计规范（先贴这一段，再贴页面 Prompt）

```text
你是移动端产品设计师，请基于 Couple Planet 的首个 MVP 输出高保真移动端界面候选方案。

产品说明：
- 产品定位：异地情侣的双通道沟通产品（即时聊天 + 马车信封），并通过星球主页承载关系成长反馈。
- 核心体验：温柔、仪式感、可回访，不做高压效率工具感。
- 关键业务目标：在不影响即时沟通效率的前提下，强化“等待中的情绪价值”。

风格说明（必须严格遵守）：
- 风格关键词：Pink Zen, Neo-Chinese Ethereal, Soft Minimal.
- 主色调：淡粉、奶白、少量桃红渐变，点缀少量暖金。
- 视觉元素：超大圆角、柔和阴影、低对比背景纹理、轻呼吸感渐变。
- 图形隐喻：
  - Planet 不画硬核科技球体，使用 Ethereal Bloom（灵花/玉光花苞）意象。
  - Carriage 不画机械马车，使用 Zen Vessel（禅舟/灯笼舟）意象。
- 文案气质：简短、诗意、温柔，不使用生硬命令式文案。

交互说明（必须覆盖）：
- 默认、加载、空态、错误、只读 5 个状态都要有视觉方案。
- 弱网与失败重试要有清晰反馈，不破坏整体美感。
- 所有高风险动作需有“轻确认 + 可撤销”设计，不用恐吓式提示。

输出要求：
- 输出 2-3 个候选方向。
- 每个方向给出：信息层级、关键交互、风险点与取舍。
- 明确哪个方向最适合 MVP 首发，并说明理由。
```

## 4.1 星球主页（Planet Home / Ethereal Bloom）

```text
基于上面的全局设计规范，请设计 Couple Planet 的星球主页（MVP）。

页面目标：
- 用户 3 分钟内理解关系状态与今日互动成果。
- 用户能快速跳转到聊天、旅程和能量流水。

必须包含的信息结构：
1) 顶部品牌区：Planet Home + 关系标识（例如 Pink Zen）
2) 核心视觉：Ethereal Bloom（灵花）状态主体（Dormant/Warm/Active/Bloom）
3) 双卡片：Stardust / Energy（含 todayDelta）
4) 关系摘要卡：partnerNickname、boundDays、todayInteractionCount
5) Carriage 摘要卡：inTransitCount、latestEtaSeconds、入口按钮
6) 五个轻交互入口：点击、长按、上滑、点轨迹、点能量槽
7) 底部导航：Home / Garden / Cosmos / Profile

交互要求：
- 状态切换要有柔和过渡，不要硬切。
- 点击 Bloom 与长按 Bloom 的反馈应有明显差异。
- 所有入口按钮要可单手操作。

请输出 2-3 个候选方案，并给出最推荐方案与原因。
```

## 4.2 即时聊天页（Instant Chat / Zen Stream）

```text
基于上面的全局设计规范，请设计 Couple Planet 的即时聊天页（MVP）。

页面目标：
- 保持“快沟通”效率，同时与 Pink Zen 风格一致。
- 在弱网或断流场景下保持可恢复，不让用户焦虑。

必须包含：
1) 顶部信息：页面标题、关系副标题、更多操作入口
2) 连接状态提示区（例如 Reconnecting to Zen stream）+ Retry 按钮
3) 消息列表（按 createdAt），区分双方气泡样式
4) 消息状态：sending/sent/failed/read
5) 输入区：输入框、表情入口、发送按钮、附加入口
6) 马车信封升级建议入口（不干扰即时发送）

交互要求：
- failed 消息要可一键重试，且重试反馈明确。
- 输入区在键盘弹起时仍保持清爽布局。
- 视觉层次柔和，不要出现高饱和冲突色块。

请输出 2 个候选方案，并对比弱网场景的优劣。
```

## 4.3 马车信封创建与旅程页（Carriage / Zen Vessel）

```text
基于上面的全局设计规范，请设计 Couple Planet 的“马车信封创建页 + 旅程页（MVP）”。

产品说明：
- 这是情绪价值承载页，不是物流追踪工具页。
- 旅程表达应偏诗意，不要过度技术化地图细节。

业务约束：
- contentType: text/voice/image
- ETA 最短 3 分钟，最长 24 小时
- 状态机：Created -> Dispatched -> InTransit -> Arrived -> Opened（异常 Failed/Expired）
- 每日免费加急 1 次：缩短剩余时间 30%，且至少保留 2 分钟

必须包含：
1) 创建输入区与校验反馈
2) ETA 预估展示
3) Zen Vessel 主视觉卡（灯笼舟/灵舟意象）
4) Journey Progress 展示（进度与剩余时间）
5) Poetic Timeline（诗意时间轴）
   - 节点示例：Dawn Ascent / Blossom Valley / Twilight Rest
6) 到达后开启动作 + 加急入口（含次数与限制提示）

交互要求：
- 时间轴节点需可读且状态明确（已达/在途/未达）。
- 加急与开启都要防误触。
- 弱网时提供优雅降级提示，而非红色报错打断情绪。

请输出 3 个候选方案，并标注最适合 MVP 首发的方案。
```

## 4.4 绑定与解绑流程页（Bind / Unbind Settings）

```text
基于上面的全局设计规范，请设计 Couple Planet 的“绑定流程 + 解绑管理页（MVP）”。

产品说明：
- 绑定流程强调“清晰、可恢复”。
- 解绑流程强调“温和过渡、尊重关系记忆”，不是破坏性操作页。

必须包含：
1) 绑定页：邀请码生成/刷新、邀请码输入、绑定成功/失败反馈
2) 设置页：关系信息卡（头像、昵称、连接时长）
3) 解绑流程卡：Circular Progress 展示冷静期倒计时（如 14 Days Left）
4) 撤销或暂停入口（建议文案：Pause Process）
5) 生效后封存/导出/删除入口关系

交互与文案要求：
- 高风险操作必须二次确认，但文案保持温和。
- 倒计时变化应有稳定反馈，不制造焦虑。
- 建议使用“Honor the memories shared”一类语气。

请输出 2 个候选流程，并说明安全与体验的平衡点。
```

## 5. Stitch 输出到 Figma 的落地规则

- 每个候选在 Figma 中必须落到 `01_Flows` 页面
- Frame 命名统一：`Feature_Screen_State`
- 至少补齐状态：
  - `default`
  - `loading`
  - `empty`
  - `error`
  - `readOnly`
- 被选中的方案必须在 Notion `Architecture Decisions` 中记录“选用理由/放弃理由”

## 6. Stitch -> Notion -> 开发 门禁规则

1. Stitch 仅负责候选，不直接产出“开发输入包完成”结论
2. Figma 定稿 + Frame ID 绑定前，`Input Package Ready` 必须保持 `false`
3. 未补齐六链，`Dev Task.Gate Result` 必须保持 `Blocked`
4. Gate B 全部满足后才改为 `Ready`

## 7. 示例：单条 PRD 填写样板

以 `[MVP] CarriageEnvelopeCore` 为例：

- `Stitch Options Link`: `https://<stitch-workspace>/carriage-v1`
- `Figma Frame URL`: `https://www.figma.com/file/<id>`
- `Figma Frame ID`: `Carriage_Journey_InTransit`
- `Architecture Decision Link`: `ADR-004`
- `Architecture Diagram Path`: `docs/architecture/system-context.mmd`
- `Input Package Ready`: `true`（仅在状态与交互说明都齐全后）

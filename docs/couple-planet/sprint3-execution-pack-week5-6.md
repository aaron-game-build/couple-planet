# 情侣星球 Sprint3 可开工包（Week5-6）

## 1. 目标与范围

本开工包覆盖 `mvp-delivery-backlog-v1` 中 Sprint3 的核心能力：

- FE-06 星球主页与状态机表现
- FE-07 星球轻交互与快捷跳转
- BE-05 星球状态与能量流水服务

本期目标：

- 让用户在星球页明确感知“互动 -> 状态变化 -> 成长反馈”
- 打通星球与马车信封、能量系统的可视化联动

## 2. API 合同草案（v0）

统一约定：

- Base Path: `/api/v1`
- Auth: `Authorization: Bearer <token>`
- 时间字段：ISO8601 UTC 字符串

## 2.1 星球主页数据

### `GET /planet/home`

- 返回：
  - `relation`: `{ relationId, partnerNickname, boundDays, todayInteractionCount }`
  - `planet`: `{ state, stateUpdatedAt, weatherTheme, dayNightTheme }`
  - `carriage`: `{ inTransitCount, latestEnvelopeId, latestEtaSeconds }`
  - `energy`: `{ totalEnergy, todayDelta, recentChanges[] }`
  - `stardust`: `{ totalStardust }`

### `GET /planet/logs?days=7`

- 返回：
  - `items`: `[{ date, interactionCount, envelopeCount, state, energyDelta }]`

## 2.2 星球状态推进

### `POST /planet/state/evaluate`

- 描述：服务端重新计算状态（内部任务/调试可用）
- 请求体：
  - `relationId`: string
- 返回：
  - `stateBefore`: `"Dormant" | "Warm" | "Active" | "Bloom"`
  - `stateAfter`: `"Dormant" | "Warm" | "Active" | "Bloom"`
  - `reason`: string

状态规则（MVP）：

- `Dormant`: 24h 无互动
- `Warm`: 当日有即时互动
- `Active`: 当日有马车信封发送或开启
- `Bloom`: 连续 3 天有互动

## 2.3 能量流水

### `GET /planet/energy/ledger?cursor=<id>&limit=20`

- 返回：
  - `items`: `[{ ledgerId, changeType, delta, balanceAfter, occurredAt, refType, refId }]`
  - `nextCursor`: string | null

### `POST /planet/energy/consume`

- 描述：能量消耗（如加急、信纸）
- 请求体：
  - `consumeType`: `"urgent" | "paper_unlock"`
  - `amount`: number
  - `refId`: string
- 返回：
  - `result`: `{ applied, balanceAfter, reason }`

## 2.4 WebSocket 事件（星球）

- 服务端事件：
  - `planet.state_changed`
  - `planet.energy_changed`
  - `planet.stardust_changed`
  - `planet.home_refresh_hint`

事件包结构：

- `event`: string
- `payload`: object
- `traceId`: string
- `occurredAt`: string

## 2.5 错误码约定（Sprint3）

- `PLANET_404_RELATION_NOT_FOUND`
- `PLANET_409_STATE_TRANSITION_INVALID`
- `ENERGY_400_INVALID_AMOUNT`
- `ENERGY_409_INSUFFICIENT_BALANCE`

## 3. 页面与字段清单（Sprint3）

## 3.1 星球主页

展示字段：

- `partnerNickname`
- `boundDays`
- `planetState`
- `todayInteractionCount`
- `inTransitCount`
- `latestEtaSeconds`
- `totalEnergy`
- `todayEnergyDelta`
- `totalStardust`

交互：

- 点击星球：今日互动摘要
- 长按星球：关键时刻回放（最近到达信封）
- 上滑：7 日日志
- 点在途轨迹：跳旅程页
- 点能量槽：跳能量流水

## 3.2 能量流水页

展示字段：

- `delta`
- `changeType`
- `balanceAfter`
- `occurredAt`
- `refType`

## 3.3 星球日志页（7天）

展示字段：

- `date`
- `interactionCount`
- `envelopeCount`
- `state`
- `energyDelta`

## 4. 埋点字段表（Sprint3）

公共字段：

- `eventName`
- `eventTime`
- `userId`
- `relationId`
- `platform`
- `appVersion`
- `traceId`

### 4.1 星球访问与状态

- `planet_page_enter`
  - 扩展字段：`source`（coldStart/notification/back）
- `planet_state_render`
  - 扩展字段：`state`
- `planet_state_changed`
  - 扩展字段：`fromState`、`toState`、`reason`

### 4.2 星球交互

- `planet_interaction_tap`
- `planet_interaction_long_press`
- `planet_interaction_swipe_up`
- `planet_to_carriage_journey_click`
- `planet_energy_panel_open`

### 4.3 能量与星屑

- `planet_energy_ledger_view`
  - 扩展字段：`entryCount`
- `planet_energy_change`
  - 扩展字段：`changeType`、`delta`、`balanceAfter`
- `planet_stardust_change`
  - 扩展字段：`delta`、`totalAfter`

## 5. 验收标准（Sprint3）

产品验收：

- 用户能在星球页清晰看到当前状态与今日互动摘要
- 用户可完成 5 个轻交互并正确跳转
- 马车相关行为可驱动星球状态变化

技术验收：

- 星球页关键交互响应 < 200ms
- 状态变更事件可达率 >= 99.5%
- 能量账本不出现负值异常

测试验收：

- 覆盖状态流转边界（24h 回落、连续 3 天升级）
- 覆盖能量增减一致性
- P0 阻断缺陷为 0

## 6. 联调计划（建议）

- Day 1-2：星球主页接口联调 + UI 骨架
- Day 3-4：状态机规则与事件联调
- Day 5-6：5 个轻交互联调 + 跳转稳定性
- Day 7-8：能量流水联调 + 账本一致性校验
- Day 9-10：回归测试 + 埋点验收 + Sprint 演示

## 7. 风险与兜底

- 状态机误判：
  - 增加服务端定时重算任务（每日）
- 实时事件不稳定：
  - 页面恢复时调用 `GET /planet/home` 主动补齐
- 星球渲染性能波动：
  - 低端机降级动画帧率与特效数量

## 8. 冻结规则

- Sprint3 不引入 3D 房间和家具系统
- 不开放星屑消费功能（仅展示累计）
- 不新增社交社区入口

## 9. 关联文档

- `docs/couple-planet/mvp-prd-v1.md`
- `docs/couple-planet/mvp-delivery-backlog-v1.md`
- `docs/couple-planet/planet-mvp-role-spec.md`

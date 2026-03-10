# 情侣星球 Sprint2 可开工包（Week3-4）

## 1. 目标与范围

本开工包覆盖 `mvp-delivery-backlog-v1` 中 Sprint2 的 P0 能力：

- FE-04 马车信封发送入口与升级建议卡
- FE-05 马车旅程页（ETA/里程/事件）
- BE-03 马车信封调度服务
- BE-04 路径与 ETA 计算服务

目标是完成“可用且可测”的马车信封主链路：

- 创建信封 -> 派发 -> 在途 -> 到达 -> 开启

## 2. API 合同草案（v0）

统一约定：

- Base Path: `/api/v1`
- Auth: `Authorization: Bearer <token>`
- 时间字段：ISO8601 UTC 字符串
- ID 字段：`string`（UUID）

## 2.1 马车信封创建与查询

### `POST /carriage/envelopes`

- 描述：创建马车信封并返回初始 ETA
- 请求体：
  - `contentType`: `"text" | "voice" | "image"`
  - `textContent`: string（`contentType=text` 时必填）
  - `voiceUrl`: string（`contentType=voice` 时必填）
  - `imageUrl`: string（`contentType=image` 时必填）
  - `clientEnvelopeId`: string
  - `isUrgent`: boolean（默认 false）
- 返回：
  - `envelope`: `{ envelopeId, status, etaSeconds, distanceMeters, createdAt }`
  - `journey`: `{ routeVersion, startPoint, endPoint }`

### `GET /carriage/envelopes/{envelopeId}`

- 返回：
  - `envelope`: `{ envelopeId, status, etaSeconds, remainingSeconds, distanceMeters, createdAt, arrivedAt, openedAt }`
  - `events`: `[{ eventId, eventType, effectType, effectValue, occurredAt }]`

### `GET /carriage/envelopes/current?cursor=<id>&limit=20`

- 描述：当前关系下信封列表
- 返回：
  - `items`: `[{ envelopeId, contentType, status, etaSeconds, createdAt, arrivedAt }]`
  - `nextCursor`: string | null

## 2.2 信封状态操作

### `POST /carriage/envelopes/{envelopeId}/open`

- 描述：接收方开启信封
- 请求体：
  - `openedAt`: string
- 返回：
  - `envelope`: `{ envelopeId, status, openedAt }`
  - `reward`: `{ energyDelta, stardustDelta }`

### `POST /carriage/envelopes/{envelopeId}/urgent`

- 描述：加急信封（每日 1 次免费）
- 请求体：
  - `clientActionId`: string
- 返回：
  - `envelope`: `{ envelopeId, status, etaSeconds, remainingSeconds }`
  - `urgentResult`: `{ applied, minWaitRespected, reason }`

## 2.3 路径与 ETA 相关接口

### `POST /routing/estimate`

- 描述：创建前预估 ETA（用于发送页展示）
- 请求体：
  - `senderLat`: number
  - `senderLng`: number
  - `receiverLat`: number
  - `receiverLng`: number
  - `transportMode`: `"drive"`
- 返回：
  - `etaSeconds`: number
  - `distanceMeters`: number
  - `degradeMode`: `"none" | "cityFallback" | "speedFallback"`

### `GET /routing/health`

- 描述：地图服务与降级状态监控接口（内部）
- 返回：
  - `mapProviderStatus`: `"ok" | "degraded" | "down"`
  - `fallbackRate`: number

## 2.4 WebSocket 事件（马车信封）

- 服务端事件：
  - `carriage.envelope.created`
  - `carriage.envelope.status_changed`
  - `carriage.envelope.arrived`
  - `carriage.envelope.opened`
  - `carriage.envelope.event_triggered`
- 客户端事件：
  - `carriage.envelope.create`
  - `carriage.envelope.open`
  - `carriage.envelope.urgent`

事件包通用结构：

- `event`: string
- `payload`: object
- `traceId`: string
- `occurredAt`: string

## 2.5 错误码约定（Sprint2）

- `CARRIAGE_400_INVALID_CONTENT`
- `CARRIAGE_404_ENVELOPE_NOT_FOUND`
- `CARRIAGE_409_STATUS_CONFLICT`
- `CARRIAGE_429_URGENT_LIMIT_REACHED`
- `ROUTING_503_PROVIDER_UNAVAILABLE`
- `ROUTING_504_TIMEOUT_FALLBACK_APPLIED`

## 3. 状态机与字段约束

状态机：

- `Created -> Dispatched -> InTransit -> Arrived -> Opened`
- 异常：`Failed` / `Expired`

约束：

- 状态不可逆（禁止倒退）
- `open` 操作仅允许 `Arrived` 状态执行
- 重复 `open` 必须幂等，不重复发奖励
- `urgent` 仅允许在 `InTransit` 状态执行

核心字段：

- `status`
- `etaSeconds`
- `remainingSeconds`
- `distanceMeters`
- `routeVersion`
- `lastEventType`

## 4. 页面与字段清单（Sprint2）

## 4.1 聊天页（马车入口）

新增字段：

- `upgradeSuggestionVisible`
- `suggestionReason`（longText/voice/image/festivalWindow）
- `carriageEtaPreview`

交互：

- 一键切换即时发送/马车发送
- 信封状态卡（出发中/在途/到达）

## 4.2 马车旅程页

展示字段：

- `status`
- `etaSeconds`
- `remainingSeconds`
- `distanceMeters`
- `journeyEvents[]`
- `canUrgent`

交互：

- 手动刷新
- 加急按钮（显示剩余免费次数）
- 到达后“开启信封”按钮

## 4.3 通知落地页（可选）

展示字段：

- `envelopeId`
- `arrivedAt`
- `openActionAvailable`

## 5. 埋点字段表（Sprint2）

公共字段：

- `eventName`
- `eventTime`
- `userId`
- `relationId`
- `platform`
- `appVersion`
- `traceId`
- `envelopeId`（相关事件必填）

## 5.1 创建与发送

- `carriage_create_submit`
  - 扩展字段：`contentType`、`contentLength`、`hasUpgradeSuggestion`
- `carriage_create_result`
  - 扩展字段：`result`、`errorCode`、`etaSeconds`、`degradeMode`

## 5.2 旅程过程

- `carriage_status_changed`
  - 扩展字段：`fromStatus`、`toStatus`
- `carriage_event_triggered`
  - 扩展字段：`eventType`、`effectType`、`effectValue`
- `carriage_eta_adjusted`
  - 扩展字段：`oldEta`、`newEta`、`adjustRatio`

## 5.3 到达与开启

- `carriage_arrive`
  - 扩展字段：`actualDurationSeconds`
- `carriage_open_submit`
  - 扩展字段：`latencyFromArriveSeconds`
- `carriage_open_result`
  - 扩展字段：`result`、`energyDelta`、`stardustDelta`

## 5.4 加急行为

- `carriage_urgent_submit`
  - 扩展字段：`remainingFreeTimes`
- `carriage_urgent_result`
  - 扩展字段：`applied`、`reason`、`etaBefore`、`etaAfter`

## 6. 验收标准（Sprint2）

产品验收：

- 用户可从聊天页完成马车信封创建并看到在途状态卡
- 到达提醒后用户可成功开启信封
- 升级建议卡不阻断即时发送

技术验收：

- 信封送达成功率 >= 99%
- 状态推进链路无倒退
- 地图服务超时时可自动降级并完成送达

测试验收：

- 覆盖正常链路、加急链路、地图降级链路、重复开启幂等链路
- P0 阻断缺陷为 0

## 7. 联调计划（建议）

- Day 1-2：接口 Mock + 状态机联调脚本
- Day 3-5：创建/在途/到达主链路联调
- Day 6-7：加急与事件系统联调
- Day 8-9：降级策略与弱网回补验证
- Day 10：回归 + 埋点验收 + Sprint 演示

## 8. 风险与兜底

- 地图服务波动：
  - 启用 `cityFallback` 与 `speedFallback`
- WebSocket 抖动：
  - 客户端轮询补偿 `GET /carriage/envelopes/{id}`
- 状态错序：
  - 服务端以事件版本号校验，仅接受新版本状态写入

## 9. 冻结规则

- Sprint2 不新增内容类型（仅 text/voice/image）
- 不引入 3D 或复杂星球建造逻辑
- 仅保留 1 次免费加急策略，不扩展付费加急

## 10. 关联文档

- `docs/couple-planet/mvp-prd-v1.md`
- `docs/couple-planet/mvp-delivery-backlog-v1.md`
- `docs/couple-planet/location-routing-constraints.md`
- `docs/couple-planet/communication-boundary-spec.md`

# 情侣星球 Sprint1 可开工包（Week1-2）

## 1. 目标与范围

本开工包覆盖 `mvp-delivery-backlog-v1` 中 Sprint1 的 P0 能力：

- FE-01 注册登录与会话初始化
- FE-02 双人绑定流程
- FE-03 即时通道聊天页
- BE-01 用户与关系绑定服务
- BE-02 即时消息服务与已读状态

目标是让前后端和测试在同一周内并行启动，无需二次口头对齐。

## 2. API 合同草案（v0）

统一约定：

- Base Path: `/api/v1`
- Auth: `Authorization: Bearer <token>`
- 时间字段：ISO8601 UTC 字符串
- ID 字段：`string`（UUID）

### 2.1 认证与用户

#### `POST /auth/register`

- 请求体：
  - `phone`: string
  - `password`: string
  - `nickname`: string
- 返回：
  - `user`: `{ id, nickname, avatarUrl, createdAt }`
  - `token`: string

#### `POST /auth/login`

- 请求体：
  - `phone`: string
  - `password`: string
- 返回：
  - `user`: `{ id, nickname, avatarUrl }`
  - `token`: string

#### `GET /auth/me`

- 返回：
  - `user`: `{ id, nickname, avatarUrl, relationStatus }`

### 2.2 关系绑定

#### `POST /relations/invite-code`

- 描述：生成绑定邀请码
- 返回：
  - `inviteCode`: string
  - `expiredAt`: string

#### `POST /relations/bind`

- 请求体（二选一）：
  - `inviteCode`: string
  - `qrToken`: string
- 返回：
  - `relation`: `{ relationId, partnerUserId, partnerNickname, boundAt, status }`

#### `GET /relations/current`

- 返回：
  - `relation`: `{ relationId, status, boundDays, partner: { id, nickname, avatarUrl } }`

### 2.3 即时消息

#### `GET /chats/current/messages?cursor=<id>&limit=20`

- 返回：
  - `items`: `[{ id, senderId, contentType, content, sentAt, deliveryStatus, readAt }]`
  - `nextCursor`: string | null

#### `POST /chats/current/messages`

- 请求体：
  - `contentType`: `"text" | "emoji"`
  - `content`: string
  - `clientMsgId`: string
- 返回：
  - `message`: `{ id, senderId, contentType, content, sentAt, deliveryStatus }`

#### `POST /chats/current/messages/read`

- 请求体：
  - `messageIds`: string[]
  - `readAt`: string
- 返回：
  - `updated`: number

### 2.4 WebSocket 事件（即时消息）

- 连接：`wss://<host>/ws?token=<jwt>`
- 服务端事件：
  - `message.new`
  - `message.read`
  - `relation.updated`
- 客户端事件：
  - `message.send`
  - `message.ack`
  - `message.read`

事件包通用结构：

- `event`: string
- `payload`: object
- `traceId`: string
- `occurredAt`: string

### 2.5 错误码约定（首批）

- `AUTH_401_TOKEN_INVALID`
- `USER_409_ALREADY_BOUND`
- `RELATION_404_NOT_FOUND`
- `CHAT_429_RATE_LIMITED`
- `CHAT_500_DELIVERY_FAILED`

## 3. 页面与字段清单（Sprint1）

## 3.1 登录/注册页

必填字段：

- 手机号
- 密码
- 昵称（注册）

状态字段：

- `isSubmitting`
- `errorCode`
- `errorMessage`

## 3.2 绑定页

展示字段：

- 我的邀请码
- 邀请码有效期
- 当前关系状态（未绑定/已绑定）
- 对方昵称（绑定后）

输入字段：

- 邀请码输入框

## 3.3 聊天页（即时通道）

消息字段：

- `id`
- `senderId`
- `contentType`
- `content`
- `sentAt`
- `deliveryStatus`（sending/sent/failed）
- `readAt`

会话字段：

- `relationId`
- `partnerNickname`
- `partnerOnline`（可选，Sprint1 可固定 false）

交互字段：

- 输入框文案
- 发送按钮禁用态
- 重发按钮可见态

## 4. 埋点字段表（Sprint1）

事件统一公共字段：

- `eventName`
- `eventTime`
- `userId`
- `relationId`（未绑定时可空）
- `platform`（ios/android）
- `appVersion`
- `traceId`

### 4.1 账号与绑定

- `auth_register_submit`
  - 扩展字段：`hasNickname`、`result`
- `auth_login_submit`
  - 扩展字段：`result`
- `relation_bind_submit`
  - 扩展字段：`bindMethod`（inviteCode/qr）、`result`、`errorCode`
- `relation_bind_success`
  - 扩展字段：`bindLatencyMs`

### 4.2 即时消息

- `message_send_instant`
  - 扩展字段：`contentType`、`contentLength`、`clientMsgId`
- `message_send_result`
  - 扩展字段：`clientMsgId`、`result`、`errorCode`、`latencyMs`
- `message_read_sync`
  - 扩展字段：`messageCount`

### 4.3 页面行为

- `page_view_login`
- `page_view_bind`
- `page_view_chat`
- `chat_click_resend`

## 5. 验收标准（Sprint1）

产品验收：

- 新用户可在 3 分钟内完成注册、绑定并发送第一条即时消息。
- 聊天消息发送失败时可重发，且不出现重复消息。

技术验收：

- 即时消息发送成功率 >= 99.9%（灰度环境）
- WebSocket 断开后 10 秒内自动重连
- 核心埋点可在数据面板看到（延迟 < 5 分钟）

测试验收：

- 覆盖正常链路、弱网链路、token 过期链路
- P0 阻断缺陷为 0

## 6. 联调计划（建议）

- Day 1-2：接口 Mock + 前端页面骨架
- Day 3-5：真实接口联调（登录、绑定、发消息）
- Day 6-8：弱网与异常链路修复
- Day 9-10：测试回归 + 埋点验收 + Sprint 演示

## 7. 冻结规则

- Sprint1 冻结新增需求范围，仅修复阻断问题
- 新增字段遵循“向后兼容，不删除旧字段”

## 8. 关联文档

- `docs/couple-planet/mvp-prd-v1.md`
- `docs/couple-planet/mvp-delivery-backlog-v1.md`
- `docs/couple-planet/communication-boundary-spec.md`

# Week1 API 契约冻结（v1）

## 1. 全局约定

- Base URL: `/api/v1`
- Auth: `Authorization: Bearer <jwt>`
- Content-Type: `application/json`
- 时间字段使用 ISO8601（UTC）
- 所有响应包含：
  - `success`: boolean
  - `requestId`: string
  - `data`: object | null
  - `error`: object | null

错误对象结构：

- `code`: string
- `message`: string
- `details`: object | null

---

## 2. Auth 接口

## 2.1 `POST /auth/register`

请求：

```json
{
  "account": "user@example.com",
  "password": "12345678",
  "nickname": "Aaron"
}
```

校验：

- `account`: 必填，邮箱格式
- `password`: 必填，长度 >= 8
- `nickname`: 必填，长度 1-20

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "user": {
      "id": "u_001",
      "account": "user@example.com",
      "nickname": "Aaron",
      "createdAt": "2026-03-09T10:00:00Z"
    },
    "token": "jwt_token"
  },
  "error": null
}
```

错误码：

- `AUTH_400_INVALID_PAYLOAD`
- `AUTH_409_ACCOUNT_EXISTS`

## 2.2 `POST /auth/login`

请求：

```json
{
  "account": "user@example.com",
  "password": "12345678"
}
```

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "user": {
      "id": "u_001",
      "account": "user@example.com",
      "nickname": "Aaron"
    },
    "token": "jwt_token"
  },
  "error": null
}
```

错误码：

- `AUTH_400_INVALID_PAYLOAD`
- `AUTH_401_CREDENTIALS_INVALID`

## 2.3 `GET /auth/me`

请求头：

- `Authorization: Bearer <jwt>`

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "user": {
      "id": "u_001",
      "account": "user@example.com",
      "nickname": "Aaron"
    }
  },
  "error": null
}
```

错误码：

- `AUTH_401_TOKEN_INVALID`

---

## 3. Relation 接口

## 3.1 `POST /relations/invite-code`

说明：生成当前用户可用的邀请码。

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "inviteCode": "CP-4FJ9KQ",
    "expiresAt": "2026-03-10T10:00:00Z"
  },
  "error": null
}
```

错误码：

- `AUTH_401_TOKEN_INVALID`
- `RELATION_409_ALREADY_BOUND`

## 3.2 `POST /relations/bind`

请求：

```json
{
  "inviteCode": "CP-4FJ9KQ"
}
```

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "relation": {
      "relationId": "r_001",
      "status": "active",
      "boundAt": "2026-03-09T11:00:00Z",
      "partner": {
        "id": "u_002",
        "nickname": "Moon"
      }
    }
  },
  "error": null
}
```

错误码：

- `AUTH_401_TOKEN_INVALID`
- `RELATION_400_INVITE_CODE_INVALID`
- `RELATION_410_INVITE_CODE_EXPIRED`
- `RELATION_409_ALREADY_BOUND`
- `RELATION_409_SELF_BIND_FORBIDDEN`

## 3.3 `GET /relations/current`

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "relation": {
      "relationId": "r_001",
      "status": "active",
      "boundAt": "2026-03-09T11:00:00Z",
      "partner": {
        "id": "u_002",
        "nickname": "Moon"
      }
    }
  },
  "error": null
}
```

错误码：

- `AUTH_401_TOKEN_INVALID`
- `RELATION_404_NOT_BOUND`

---

## 4. Chat 接口

## 4.1 `GET /chats/current/messages?cursor=<messageId>&limit=20`

说明：

- `cursor` 可选，首屏为空
- `limit` 默认 20，最大 50

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "items": [
      {
        "id": "m_1001",
        "clientMsgId": "cm_001",
        "senderId": "u_001",
        "content": "hello",
        "status": "sent",
        "createdAt": "2026-03-09T11:10:00Z",
        "readAt": null
      }
    ],
    "nextCursor": "m_0990"
  },
  "error": null
}
```

错误码：

- `AUTH_401_TOKEN_INVALID`
- `RELATION_404_NOT_BOUND`

## 4.2 `POST /chats/current/messages`

请求：

```json
{
  "clientMsgId": "cm_001",
  "content": "hello"
}
```

校验：

- `clientMsgId` 必填（客户端幂等键）
- `content` 必填，长度 1-1000

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "message": {
      "id": "m_1001",
      "clientMsgId": "cm_001",
      "senderId": "u_001",
      "content": "hello",
      "status": "sent",
      "createdAt": "2026-03-09T11:10:00Z"
    },
    "idempotentHit": false
  },
  "error": null
}
```

幂等规则：

- 以 `(sender_id, client_msg_id)` 唯一键判定重复请求。
- 若命中重复，返回已存在消息，`idempotentHit = true`。

错误码：

- `AUTH_401_TOKEN_INVALID`
- `RELATION_404_NOT_BOUND`
- `CHAT_400_INVALID_CONTENT`

## 4.3 `POST /chats/current/messages/read`

请求：

```json
{
  "messageIds": ["m_1001", "m_1002"]
}
```

成功响应：

```json
{
  "success": true,
  "requestId": "req_xxx",
  "data": {
    "updated": 2,
    "readAt": "2026-03-09T11:20:00Z"
  },
  "error": null
}
```

错误码：

- `AUTH_401_TOKEN_INVALID`
- `RELATION_404_NOT_BOUND`
- `CHAT_400_INVALID_MESSAGE_IDS`

---

## 5. 错误码总表（Week1）

- `AUTH_400_INVALID_PAYLOAD`
- `AUTH_401_TOKEN_INVALID`
- `AUTH_401_CREDENTIALS_INVALID`
- `AUTH_409_ACCOUNT_EXISTS`
- `RELATION_400_INVITE_CODE_INVALID`
- `RELATION_404_NOT_BOUND`
- `RELATION_409_ALREADY_BOUND`
- `RELATION_409_SELF_BIND_FORBIDDEN`
- `RELATION_410_INVITE_CODE_EXPIRED`
- `CHAT_400_INVALID_CONTENT`
- `CHAT_400_INVALID_MESSAGE_IDS`


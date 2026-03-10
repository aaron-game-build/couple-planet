# Week1 后端九接口联调脚本

## 0. 准备

- 启动 API：`pnpm dev:api`（或在 `apps/api` 下 `npm run dev`）
- Base URL：`http://localhost:3000/api/v1`
- 准备两个测试账号：A、B（邮箱不同）

说明：当前环境未安装 `pnpm` 且 npm 镜像访问受限，未能在此会话内执行依赖安装与真实启动；脚本已按实现代码编写，可在你本机正常 npm registry 环境直接运行。

## 1. 注册与登录

### 1.1 注册 A

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"account":"a@example.com","password":"12345678","nickname":"A"}'
```

### 1.2 注册 B

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"account":"b@example.com","password":"12345678","nickname":"B"}'
```

### 1.3 登录并保存 token

```bash
TOKEN_A=$(curl -s -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"account":"a@example.com","password":"12345678"}' | jq -r '.data.token')

TOKEN_B=$(curl -s -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"account":"b@example.com","password":"12345678"}' | jq -r '.data.token')
```

## 2. 绑定关系

### 2.1 A 生成邀请码

```bash
INVITE_CODE=$(curl -s -X POST http://localhost:3000/api/v1/relations/invite-code \
  -H "Authorization: Bearer $TOKEN_A" | jq -r '.data.inviteCode')
```

### 2.2 B 使用邀请码绑定

```bash
curl -X POST http://localhost:3000/api/v1/relations/bind \
  -H "Authorization: Bearer $TOKEN_B" \
  -H "Content-Type: application/json" \
  -d "{\"inviteCode\":\"$INVITE_CODE\"}"
```

### 2.3 双方查询 current relation

```bash
curl -X GET http://localhost:3000/api/v1/relations/current \
  -H "Authorization: Bearer $TOKEN_A"

curl -X GET http://localhost:3000/api/v1/relations/current \
  -H "Authorization: Bearer $TOKEN_B"
```

## 3. 即时消息

### 3.1 A 发送消息

```bash
curl -X POST http://localhost:3000/api/v1/chats/current/messages \
  -H "Authorization: Bearer $TOKEN_A" \
  -H "Content-Type: application/json" \
  -d '{"clientMsgId":"cm_001","content":"hello from A"}'
```

### 3.2 B 拉取消息

```bash
curl -X GET "http://localhost:3000/api/v1/chats/current/messages?limit=20" \
  -H "Authorization: Bearer $TOKEN_B"
```

### 3.3 B 标记已读

```bash
curl -X POST http://localhost:3000/api/v1/chats/current/messages/read \
  -H "Authorization: Bearer $TOKEN_B" \
  -H "Content-Type: application/json" \
  -d '{"messageIds":["<替换为上一步消息ID>"]}'
```

## 4. 幂等验证

对同一个 `clientMsgId` 重复发送两次，应返回同一条消息且第二次 `idempotentHit=true`。

```bash
curl -X POST http://localhost:3000/api/v1/chats/current/messages \
  -H "Authorization: Bearer $TOKEN_A" \
  -H "Content-Type: application/json" \
  -d '{"clientMsgId":"cm_dup","content":"dup check"}'

curl -X POST http://localhost:3000/api/v1/chats/current/messages \
  -H "Authorization: Bearer $TOKEN_A" \
  -H "Content-Type: application/json" \
  -d '{"clientMsgId":"cm_dup","content":"dup check"}'
```

## 5. 错误码抽查

### 5.1 无 token 访问

```bash
curl -X GET http://localhost:3000/api/v1/auth/me
```

期望：`error.code = AUTH_401_TOKEN_INVALID`

### 5.2 重复绑定

绑定完成后，再次调用 `/relations/bind`。

期望：`error.code = RELATION_409_ALREADY_BOUND`

## 6. Go / No-Go

Go 条件：

- 9 个接口均可访问并返回统一结构
- 绑定链路成功
- 消息发送、拉取、已读、幂等验证通过
- 抽查错误码正确

No-Go 条件：

- 任一主链路接口不可用
- 幂等失败导致重复消息
- 鉴权错误码不一致


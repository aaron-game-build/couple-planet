# Week1 NestJS 模块与职责冻结（v1）

## 1. 目录结构（建议）

```txt
src/
  app.module.ts
  common/
    guards/jwt-auth.guard.ts
    filters/http-exception.filter.ts
    interceptors/request-id.interceptor.ts
  infra/
    prisma/ (或 typeorm)
    jwt/jwt.service.ts
  modules/
    auth/
      auth.module.ts
      auth.controller.ts
      auth.service.ts
      dto/
    relation/
      relation.module.ts
      relation.controller.ts
      relation.service.ts
      dto/
    chat/
      chat.module.ts
      chat.controller.ts
      chat.service.ts
      dto/
```

## 2. 模块职责

## 2.1 AuthModule

Controller：

- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`

Service 职责：

- 注册：校验参数、检查 account 唯一、密码哈希入库
- 登录：校验账号密码、签发 JWT
- me：从 token 解析 user 并返回最小信息

必须保证：

- 统一抛出错误码（不直接抛 DB 错误）
- 密码只存 hash（不可明文）

## 2.2 RelationModule

Controller：

- `POST /relations/invite-code`
- `POST /relations/bind`
- `GET /relations/current`

Service 职责：

- 生成邀请码（带过期时间）
- 绑定关系：
  - 禁止自绑定
  - 禁止重复绑定
  - 校验邀请码有效性与过期
- 查询当前关系与 partner 信息

必须保证：

- 绑定写操作使用事务
- 绑定冲突返回业务错误码（不是 500）

## 2.3 ChatModule

Controller：

- `GET /chats/current/messages`
- `POST /chats/current/messages`
- `POST /chats/current/messages/read`

Service 职责：

- 拉取历史：按 `relation_id + created_at desc` 分页
- 发送消息：
  - 校验用户已绑定
  - 处理 `clientMsgId` 幂等
- 已读回写：批量更新 read_at

必须保证：

- 幂等命中时返回已有消息
- 非绑定关系禁止发消息

## 3. 关键 Service 方法签名（示意）

## AuthService

- `register(dto: RegisterDto): Promise<AuthResult>`
- `login(dto: LoginDto): Promise<AuthResult>`
- `me(userId: string): Promise<UserProfile>`

## RelationService

- `createInviteCode(userId: string): Promise<InviteCodeResult>`
- `bindByInviteCode(userId: string, dto: BindDto): Promise<RelationResult>`
- `getCurrentRelation(userId: string): Promise<RelationResult>`

## ChatService

- `listMessages(userId: string, cursor?: string, limit?: number): Promise<MessageListResult>`
- `sendMessage(userId: string, dto: SendMessageDto): Promise<SendMessageResult>`
- `markRead(userId: string, dto: MarkReadDto): Promise<MarkReadResult>`

## 4. DTO 冻结（最小字段）

RegisterDto：

- `account`
- `password`
- `nickname`

BindDto：

- `inviteCode`

SendMessageDto：

- `clientMsgId`
- `content`

MarkReadDto：

- `messageIds: string[]`

## 5. 中间件/守卫约定

- 除 `register/login` 外接口全部使用 `JwtAuthGuard`
- 请求统一注入 `requestId`
- 错误统一包装为标准响应格式

## 6. Week1 不做

- 复杂领域事件总线
- CQRS 拆分
- WebSocket 网关大重构
- 多模块跨服务分布式拆分

## 7. 通过标准

- 三个模块能独立单测最小用例
- 全链路联调通过（注册->绑定->发消息）
- 出错时返回可识别业务错误码


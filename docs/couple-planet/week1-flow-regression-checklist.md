# Week1 流程回归验收清单

适用范围：本地开发联调、每次改动登录/关系/聊天流程后的快速回归。

目标：确保以下关键体验不回退：
- 已绑定用户重新登录后直达聊天，不再回到绑定流程。
- 邀请码可复用且服务重启后不丢失。
- 两账号可以稳定完成 `注册 -> 登录 -> 绑定 -> 聊天` 最小闭环。

## 0. 前置条件

- API 服务已启动（默认 `http://localhost:3000`）。
- Mobile 已使用：
  - `--dart-define=API_BASE_URL=http://localhost:3000/api/v1`
- 数据库已执行迁移：
  - `apps/api/database/migrations/0001_week1_core.sql`
  - `apps/api/database/migrations/0002_relation_invites.sql`

## 1. 后端快速自测（命令行）

### 1.1 健康检查

```bash
curl -s http://localhost:3000/api/v1/health | jq
```

期望：
- `success=true`
- `data.status=ok`
- `data.db=up`

### 1.2 新建两账号并登录

```bash
TS=$(date +%s)
A="qa_${TS}_a@example.com"
B="qa_${TS}_b@example.com"

curl -s -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"account\":\"$A\",\"password\":\"12345678\",\"nickname\":\"QA_A\"}" | jq

curl -s -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"account\":\"$B\",\"password\":\"12345678\",\"nickname\":\"QA_B\"}" | jq

TOKEN_A=$(curl -s -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"account\":\"$A\",\"password\":\"12345678\"}" | jq -r '.data.token')

TOKEN_B=$(curl -s -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"account\":\"$B\",\"password\":\"12345678\"}" | jq -r '.data.token')
```

期望：
- 两次注册与登录均成功，`token` 非空。

### 1.3 邀请码刷新检查（未绑定前）

```bash
INVITE1=$(curl -s -X POST http://localhost:3000/api/v1/relations/invite-code \
  -H "Authorization: Bearer $TOKEN_A" | jq -r '.data.inviteCode')

INVITE2=$(curl -s -X POST http://localhost:3000/api/v1/relations/invite-code \
  -H "Authorization: Bearer $TOKEN_A" | jq -r '.data.inviteCode')

echo "$INVITE1"
echo "$INVITE2"
```

期望：
- `INVITE1` 与 `INVITE2` 不同（再次调用会刷新为新邀请码）。
- 使用最新邀请码可继续完成绑定。

### 1.4 绑定并验证关系

```bash
curl -s -X POST http://localhost:3000/api/v1/relations/bind \
  -H "Authorization: Bearer $TOKEN_B" \
  -H "Content-Type: application/json" \
  -d "{\"inviteCode\":\"$INVITE1\"}" | jq

curl -s -X GET http://localhost:3000/api/v1/relations/current \
  -H "Authorization: Bearer $TOKEN_A" | jq

curl -s -X GET http://localhost:3000/api/v1/relations/current \
  -H "Authorization: Bearer $TOKEN_B" | jq
```

期望：
- 绑定成功，双方 `current` 均返回 `relation`。
- A 的 partner 是 B，B 的 partner 是 A。

### 1.5 邀请码持久化检查（服务重启后）

步骤：
1. 重启 API 服务。
2. 用全新账号 C 登录并生成邀请码（记录 `INVITE_C`）。
3. 再次重启 API 服务。
4. 用全新账号 D 调用 `/relations/bind` 使用 `INVITE_C`。

期望：
- 第 4 步绑定成功（说明邀请码不依赖进程内存）。

## 2. 移动端人工验收

### 2.1 路由分流（已绑定用户）

步骤：
1. 用已绑定账号登录（如上面的 A）。
2. 观察登录后落点页面。

期望：
- 登录后直接进入 `Chat`，不会先进入 `Bind`。

### 2.2 路由分流（未绑定用户）

步骤：
1. 用全新未绑定账号登录。

期望：
- 登录后进入 `Bind`。
- 可看到“生成/刷新邀请码”按钮与邀请码展示。

### 2.3 Bind 页可恢复性

检查项：
- 有“刷新关系”按钮。
- 有“Back to Login”。
- 绑定成功后显示已绑定态和“Go to Chat”。

### 2.4 Chat 最小链路

步骤：
1. 在 Chat 输入消息并发送。
2. 点击刷新按钮确认消息可见。
3. 退出登录再登录。

期望：
- 发送成功且可拉取到消息。
- 重新登录仍直达 Chat。

## 3. 回归失败判定（No-Go）

出现任一即判定失败：
- 已绑定账号登录后仍进入 `Bind`。
- 邀请码在 API 重启后失效（未过期却不能绑定）。
- Bind 页长期 `My invite code: ...` 且无可恢复路径。
- 发送消息后无法拉取，或 `RELATION_404_NOT_BOUND` 与用户状态不一致。

## 4. 建议执行频率

- 每次改动以下模块后都跑一遍本清单：
  - `apps/mobile/lib/features/auth/*`
  - `apps/mobile/lib/features/relation/*`
  - `apps/mobile/lib/features/chat/*`
  - `apps/api/src/modules/relation/*`
  - `apps/api/src/modules/chat/*`

## 5. 执行记录（2026-03-10）

- [x] 1.1 健康检查通过：`status=ok`、`db=up`
- [x] 1.2 两账号注册/登录成功，token 非空
- [x] 1.3 邀请码刷新行为验证通过（`INVITE1 != INVITE2`）
- [x] 1.4 使用最新邀请码绑定成功，双方 `relations/current` 返回 active relation
- [x] 1.5 邀请码持久化检查（跨服务重启）已通过（见证据文档第 5 节）
- [x] 2.4 Chat 最小链路通过（发送+拉取）
- [ ] 2.1/2.2/2.3 移动端人工验收项待真机/模拟器补证据

证据来源：
- `docs/operations/cloud-dev-execution-round-002.md`
- 本轮 API 实测命令输出（账号注册、绑定、消息拉取）

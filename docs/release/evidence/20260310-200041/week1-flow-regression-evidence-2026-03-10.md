# Week1 流程回归证据（2026-03-10）
> EN: Week1 Flow Regression Evidence

## 1）环境信息

- API Base URL: `http://localhost:3000/api/v1`
- cloud-dev: 已启动（见 `docs/operations/cloud-dev-execution-round-002.md`）

## 2）关键结果摘录

### 2.1 健康检查

- Response:
  - `{"success":true,"data":{"status":"ok","db":"up"}}`

### 2.2 登录/绑定/聊天主链路

- 邀请码生成：`INVITE=CP-6AC2E5`
- 绑定结果：`success=true`
- 关系查询：`success=true` 且 `status=active`
- 消息发送：`success=true`
- 消息拉取：`success=true`，返回发送消息

## 3）差异与结论

- 文档原预期“邀请码复用（INVITE1=INVITE2）”与当前实现不一致。
- 当前实现为“再次生成邀请码会使旧 active 邀请码失效并返回新邀请码”，已在清单中同步为“邀请码刷新检查”。

## 4）待补项

- 移动端人工验收（路由分流、Bind 页可恢复性、账号切换）。
- 邀请码跨服务重启持久化验证（发布机执行重启场景）。

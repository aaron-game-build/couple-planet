# Couple Planet MVP 测试与发布资料包

## 1. 目的与真源

本文件用于整合 MVP 的测试范围、执行脚本、门禁与证据归档规范。

关联真源：

- API 契约：`docs/couple-planet/week1-api-contract.md`
- API 联调脚本：`docs/couple-planet/week1-api-verification.md`
- Day6-7 验收：`docs/couple-planet/week1-day6-day7-acceptance.md`
- 流程回归：`docs/couple-planet/week1-flow-regression-checklist.md`
- UI 门禁：`docs/couple-planet/ui-workflow.md`

## 2. 测试分层策略

## 2.1 API 契约测试

目标：保证接口结构、错误码、幂等策略稳定。

最小覆盖：

- Auth：`register/login/me`
- Relation：`invite-code/bind/current`
- Chat：`list/send/read`
- 重点断言：
  - 统一响应结构（`success/requestId/data/error`）
  - 鉴权错误码正确
  - 幂等命中返回行为稳定

## 2.2 主链路集成测试

目标：保障最小闭环可跑通。

闭环：`注册 -> 登录 -> 绑定 -> 发消息 -> 拉取 -> 已读 -> 重试`

## 2.3 移动端人工回归

目标：保证路由分流、状态渲染与失败恢复不回退。

重点：

- 已绑定用户登录后直达 Chat
- 未绑定用户登录后进入 Bind
- Bind 页可恢复性（刷新关系/回登录）
- Chat 最小链路可见

## 2.4 发布门禁测试

目标：确保 Go/No-Go 有证据支撑，不口头发布。

- `flutter analyze` 通过
- 关键回归项全部执行
- P0 为 0
- 证据链完整可追溯

## 3. 测试矩阵（MVP 全周期）

| Sprint | 范围 | API 验证 | 移动端回归 | 关键门禁 |
|---|---|---|---|---|
| Sprint1 | 账号/绑定/即时消息 | Week1 九接口 | 登录/绑定/聊天最小链路 | 绑定成功率、消息成功率 |
| Sprint2 | 马车信封/ETA | carriage + routing 合同 | 信封创建/在途/到达/开启 | 状态不可逆、到达可开启 |
| Sprint3 | 星球状态/能量 | planet + energy 合同 | 星球四态与轻交互 | 状态变更反馈时延 |
| Sprint4 | 解绑/封存/埋点 | unbind + archive + analytics | 解绑倒计时/撤销/生效 | 冷静期正确性、合规证据 |

## 4. 可执行测试清单（首发版）

## 4.1 API 联调（命令行）

直接执行：`docs/couple-planet/week1-api-verification.md`

通过标准：

- 9 个接口可访问
- 绑定链路成功
- 消息发送/拉取/已读通过
- 幂等验证通过
- 抽查错误码正确

## 4.2 Day6-Day7 验收

直接执行：`docs/couple-planet/week1-day6-day7-acceptance.md`

Go 条件（必须同时满足）：

- 两个账号稳定完成注册、绑定、互发消息
- 消息发送成功率 >= 99%
- P0 缺陷 = 0

No-Go 条件（任一命中）：

- 存在 P0
- 消息成功率 < 99%
- 绑定流程高概率失败

## 4.3 流程回归

直接执行：`docs/couple-planet/week1-flow-regression-checklist.md`

失败判定（任一命中）：

- 已绑定用户登录仍进 Bind
- 邀请码重启后失效（未过期）
- Bind 页无可恢复路径
- 发消息后无法拉取或关系态不一致

## 5. Go / No-Go 统一口径

来源统一到 `docs/couple-planet/ui-workflow.md` Gate C 与本文件。

## Go（允许发布）

- Gate C 全通过
- P0 = 0
- 主链路成功率达到阈值
- `Release & Regression` 已补齐：
  - `Go No-Go`
  - `P0 P1 Summary`
  - `Evidence Bundle`

## No-Go（禁止发布）

- 任一主链路阻断
- 证据缺失或不可复现
- 关键错误码返回不一致
- 幂等或鉴权策略失效

## 6. 证据归档模板（可复制到 Notion）

```text
ReleaseCandidate: MVP-Sx-WeekY
Date:
Owner:

Scope:
- FE:
- BE:
- QA:

TestExecution:
- API contract verification: pass/fail
- Integration flow: pass/fail
- Mobile regression: pass/fail
- Weak network retry: pass/fail

Defects:
- P0:
- P1:
- P2:

Metrics:
- Bind completion rate:
- Message send success rate:
- Carriage delivery success rate:

GoNoGo:
- Decision: Go / No-Go
- Reason:

EvidenceLinks:
- API logs:
- Screenshots:
- Videos:
- Issue links:
```

## 7. 测试任务拆分建议（可直接转 Dev Tasks / QA Tasks）

- `QA-API-001`：Auth/Relation/Chat 合同回归
- `QA-FLOW-001`：注册到聊天最小闭环
- `QA-RESILIENCE-001`：弱网失败重试与幂等
- `QA-MOBILE-ROUTING-001`：登录后路由分流
- `QA-RELEASE-GATE-001`：Gate C 发布门禁复核

## 8. 与发布流程的衔接

- 执行发布前检查：`docs/release/release-checklist.md`
- 保留 Go/No-Go 结论：`docs/release/go-no-go-latest.md`
- iOS 交付流程：`docs/release/ios-testflight-flow.md`

要求：

- 发布结论必须有证据链接
- 证据必须可追溯到 Requirement 与 Dev Task

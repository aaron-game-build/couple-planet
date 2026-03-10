# 情侣星球个人开发 Week1 执行清单（基础链路）

## 本周目标

只交付 3 件事：

1. 登录
2. 绑定
3. 即时聊天

验收口径：两个人可以在真机上完成注册绑定并互发文字消息。

## 功能最小范围

- 登录：邮箱或手机号二选一即可（建议先邮箱，省短信成本）
- 绑定：邀请码绑定
- 聊天：仅文字消息（不做语音、图片、表情商城）

## 最小 API 清单（必须先锁定）

- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`
- `POST /relations/invite-code`
- `POST /relations/bind`
- `GET /relations/current`
- `GET /chats/current/messages`
- `POST /chats/current/messages`
- `POST /chats/current/messages/read`

## 最小页面清单（必须先锁定）

- 登录/注册页
- 绑定页（邀请码输入）
- 聊天页（文字输入框 + 消息列表）

## 开发顺序（个人开发版）

1. 先做后端最小 API（登录、绑定、发消息）
2. 再做前端 3 个页面骨架
3. 接 WebSocket 或轮询（任选一种，优先你熟悉的）
4. 真机双账号联调

## 每日可执行任务（7 天）

- Day 1：建库、建表、注册登录 API 跑通
- Day 2：绑定关系 API 跑通
- Day 3：聊天发送/拉取 API 跑通
- Day 4：前端登录/绑定页面接通
- Day 5：前端聊天页面接通
- Day 6：双机联调 + 弱网重试
- Day 7：修 bug + 记录指标

## 数据结构最小建议

- `users`：`id`, `email_or_phone`, `password_hash`, `nickname`, `created_at`
- `relations`：`id`, `user_a`, `user_b`, `status`, `bound_at`
- `messages`：`id`, `relation_id`, `sender_id`, `content`, `sent_at`, `read_at`

## 本周验收 checklist

- [ ] 新用户 3 分钟内完成注册+绑定
- [ ] 聊天消息可发送、可看到、可标记已读
- [ ] 失败消息可重发，且不重复落库
- [ ] 至少 2 台设备真机联调通过

## 本周只看 2 个数

- 绑定完成率
- 即时消息发送成功率

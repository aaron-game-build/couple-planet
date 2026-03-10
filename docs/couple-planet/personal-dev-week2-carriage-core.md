# 情侣星球个人开发 Week2 执行清单（马车信封闭环）

## 本周目标

只做一条链路：`创建 -> 在途 -> 到达 -> 开启`

验收口径：两个人可以稳定发送并开启文字马车信封。

## 功能最小范围

- 只支持文字信封
- 有 ETA（估算即可）
- 有在途状态
- 到达后可开启

不做：

- 语音/图片信封
- 复杂随机事件
- 复杂动画

## 最小 API 清单

- `POST /carriage/envelopes`（创建信封）
- `GET /carriage/envelopes/{id}`（查状态）
- `POST /carriage/envelopes/{id}/open`（开启信封）
- `POST /routing/estimate`（ETA 估算）

## 状态机（只保留 5 个状态）

- `Created`
- `InTransit`
- `Arrived`
- `Opened`
- `Failed`

规则：

- 状态不可倒退
- 只有 `Arrived` 才能 `Opened`
- 重复 `open` 幂等，不重复奖励

## 页面最小清单

- 聊天页新增“发马车信封”按钮
- 在途卡片（显示剩余时间）
- 到达后“开启信封”按钮

## ETA 极简实现

- 先走“离散定位 + 路径估算”
- 没有定位权限时使用城市级估算
- 兜底固定速度（如 50km/h）

边界值：

- 最短 3 分钟
- 最长 24 小时

## 每日可执行任务（7 天）

- Day 1：信封表结构 + 创建接口
- Day 2：状态推进任务（定时或队列）
- Day 3：到达与开启接口
- Day 4：聊天页加信封入口与状态卡
- Day 5：ETA 展示与到达提醒
- Day 6：异常兜底（超时、失败、重试）
- Day 7：双机联调 + 指标记录

## 数据结构最小建议

- `carriage_envelopes`：`id`, `relation_id`, `sender_id`, `content`, `status`, `eta_seconds`, `created_at`, `arrived_at`, `opened_at`
- `carriage_events`：`id`, `envelope_id`, `event_type`, `payload`, `occurred_at`

## 本周验收 checklist

- [ ] 信封可创建并进入在途
- [ ] 到达后可开启，开启后不可重复奖励
- [ ] 失败态可见，用户可重试
- [ ] 无定位权限场景也能发送信封

## 本周只看 2 个数

- 信封送达成功率
- 信封平均到达时长偏差（预计 vs 实际）

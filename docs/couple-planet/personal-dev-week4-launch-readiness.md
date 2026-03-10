# 情侣星球个人开发 Week4 执行清单（上线收尾）

## 本周目标

只做上线必需闭环：

1. 解绑冷静期（72 小时）
2. 基础埋点与错误监控
3. 小规模灰度（20-50 对情侣）

验收口径：功能可稳定运行，关键数据可看到，能收集真实反馈。

## 功能最小范围

解绑流程最简版：

- 发起解绑
- 进入 `UnbindPending`
- 冷静期倒计时
- 可撤销
- 到时自动生效

不做：

- 复杂回忆封存下载
- 申诉系统自动化

## 最小 API 清单

- `POST /relations/unbind/apply`
- `POST /relations/unbind/cancel`
- `GET /relations/unbind/status`
- `POST /analytics/events/batch`

## 最小埋点清单（必须有）

- `relation_bind_success`
- `message_send_instant`
- `carriage_create_result`
- `carriage_arrive`
- `carriage_open_result`
- `unbind_apply`
- `unbind_effective`

## 监控最小清单（必须有）

- 服务端错误率（5xx）
- 聊天发送成功率
- 信封送达成功率
- App 崩溃率（如可接入）

## 灰度执行方式（个人开发版）

- 先内测 5-10 对（朋友）
- 再扩到 20-50 对
- 观察 3 天后再决定扩大范围

## 每日可执行任务（7 天）

- Day 1：解绑状态机 + 定时生效任务
- Day 2：解绑页面与倒计时展示
- Day 3：埋点接入（最小事件）
- Day 4：错误日志与告警配置
- Day 5：内测 5-10 对，收集问题
- Day 6：修复阻断 bug，扩灰度到 20-50 对
- Day 7：复盘数据并决定下一轮

## 本周验收 checklist

- [ ] 解绑可发起、可撤销、可自动生效
- [ ] 关键埋点数据可在后台查到
- [ ] 信封送达成功率可观测
- [ ] 至少完成 20 对灰度测试

## 上线继续迭代条件

满足以下条件再继续扩功能：

- 信封送达成功率 >= 98%
- 首周发过马车信封的情侣占比 >= 30%
- 次日留存 >= 35%

若不满足：

- 优先优化发送链路复杂度
- 优先优化到达提醒体验

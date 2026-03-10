# 情侣星球 Sprint4 可开工包（Week7-8）

## 1. 目标与范围

本开工包覆盖 `mvp-delivery-backlog-v1` 中 Sprint4 核心能力：

- FE-08 解绑管理页与冷静期体验
- FE-09 回忆封存与导出申请页
- FE-10 埋点接入与看板字段校验
- BE-06 解绑冷静期、封存与导出服务
- BE-07 埋点采集与指标聚合
- BE-08 通知与推送编排
- QA-03 性能稳定性、QA-04 隐私合规

本期目标：

- 完成“可上线”的安全闭环与数据闭环
- 保障解绑与数据资产处理可审计、可回溯、可合规

## 2. API 合同草案（v0）

统一约定：

- Base Path: `/api/v1`
- Auth: `Authorization: Bearer <token>`
- 高风险接口要求二次确认凭证 `confirmToken`

## 2.1 解绑流程

### `POST /relations/unbind/apply`

- 请求体：
  - `reasonCode`: string（可选）
  - `confirmToken`: string
- 返回：
  - `unbind`: `{ status, pendingStartedAt, effectiveAt, canCancel }`

### `POST /relations/unbind/cancel`

- 请求体：
  - `confirmToken`: string
- 返回：
  - `unbind`: `{ status, cancelledAt }`

### `GET /relations/unbind/status`

- 返回：
  - `unbind`: `{ status, pendingStartedAt, effectiveAt, remainingSeconds }`

状态机：

- `Bound -> UnbindPending -> Unbound`
- 冷静期内可 `UnbindCancelled -> Bound`

## 2.2 回忆封存与导出

### `GET /archive/overview`

- 返回：
  - `archive`: `{ available, retainedUntil, itemCounts }`

### `POST /archive/export/apply`

- 请求体：
  - `exportScope`: `["chat","carriage","events","energy"]`
- 返回：
  - `task`: `{ taskId, status, createdAt, expiresAt }`

### `GET /archive/export/tasks/{taskId}`

- 返回：
  - `task`: `{ taskId, status, progress, downloadUrl, expiredAt }`

### `POST /archive/delete`

- 请求体：
  - `confirmToken`: string
- 返回：
  - `result`: `{ deleted, deletedAt }`

## 2.3 通知编排

### `POST /notify/unbind/schedule`

- 描述：创建解绑相关通知任务（内部）
- 返回：
  - `scheduled`: number

通知类型：

- `unbind_applied`
- `unbind_24h_before_effective`
- `unbind_effective`
- `archive_retention_7d_notice`

## 2.4 埋点与看板

### `POST /analytics/events/batch`

- 请求体：
  - `events`: object[]
- 返回：
  - `accepted`: number
  - `failed`: number

### `GET /analytics/kpi/daily`

- 返回：
  - `kpi`: `{ day, bindCompletionRate, carriageFirstWeekUsage, interactionFreq, d7Retention, carriageDeliverySuccess }`

## 2.5 错误码约定（Sprint4）

- `UNBIND_401_CONFIRM_REQUIRED`
- `UNBIND_409_STATUS_CONFLICT`
- `ARCHIVE_403_NOT_ALLOWED`
- `ARCHIVE_404_TASK_NOT_FOUND`
- `ARCHIVE_410_DOWNLOAD_EXPIRED`
- `ANALYTICS_400_SCHEMA_INVALID`

## 3. 页面与字段清单（Sprint4）

## 3.1 解绑管理页

展示字段：

- `unbindStatus`
- `pendingStartedAt`
- `effectiveAt`
- `remainingSeconds`
- `canCancel`

交互：

- 发起解绑（二次确认）
- 撤销解绑（冷静期内）
- 查看规则与后果说明

## 3.2 封存与导出页

展示字段：

- `archiveAvailable`
- `retainedUntil`
- `itemCounts`
- `exportTaskStatus`
- `downloadExpiredAt`

交互：

- 申请导出
- 查看导出进度
- 下载导出包
- 删除封存数据（二次确认）

## 3.3 数据看板页（内部）

展示字段：

- `bindCompletionRate`
- `carriageFirstWeekUsage`
- `interactionFreq`
- `d7Retention`
- `carriageDeliverySuccess`

## 4. 埋点字段表（Sprint4）

公共字段：

- `eventName`
- `eventTime`
- `userId`
- `relationId`
- `platform`
- `appVersion`
- `traceId`

### 4.1 解绑流程

- `unbind_apply`
  - 扩展字段：`reasonCode`、`result`、`errorCode`
- `unbind_cancel`
  - 扩展字段：`result`、`remainingSeconds`
- `unbind_effective`
  - 扩展字段：`pendingDurationSeconds`

### 4.2 封存导出

- `archive_export_apply`
  - 扩展字段：`scopeCount`、`result`
- `archive_export_ready`
  - 扩展字段：`taskDurationSeconds`
- `archive_export_download`
  - 扩展字段：`result`、`errorCode`
- `archive_delete_confirm`
  - 扩展字段：`result`

### 4.3 指标回流

- `kpi_daily_generated`
  - 扩展字段：`day`、`recordCount`
- `kpi_dashboard_view`
  - 扩展字段：`viewerRole`

## 5. 验收标准（Sprint4）

产品验收：

- 用户可完整走通“发起解绑 -> 冷静期 -> 撤销/生效”流程
- 生效后通信入口关闭，封存入口可用
- 导出任务可追踪并可下载

技术验收：

- 冷静期到点自动生效率 >= 99.9%
- 导出任务成功率 >= 99%
- 核心 KPI 每日自动生成成功率 >= 99%

安全合规验收：

- 解绑/删除全部强制二次确认
- 审计日志覆盖发起、撤销、生效、导出、删除全链路
- 生效后数据隔离错误率 = 0

测试验收：

- 覆盖单方失联、恶意骚扰静默、误操作申诉入口
- 覆盖导出过期、重复下载、重复删除幂等
- P0 阻断缺陷为 0

## 6. 联调计划（建议）

- Day 1-2：解绑状态机接口联调 + 页面骨架
- Day 3-4：封存与导出任务链路联调
- Day 5-6：通知编排联调 + 定时任务验证
- Day 7-8：埋点与 KPI 看板联调
- Day 9：性能压测 + 隐私合规回归
- Day 10：灰度演练 + Go/No-Go 评审

## 7. 上线演练清单

- 灰度范围：5% -> 20% -> 50% -> 100%
- 每阶段观察：
  - 消息成功率
  - 信封送达率
  - 解绑流程成功率
  - 崩溃率与关键接口错误率
- 回滚触发条件：
  - 信封送达率 < 98%
  - 崩溃率 > 0.5%
  - 数据隔离出现 1 例即回滚

## 8. 风险与兜底

- 导出任务堆积：
  - 任务队列限流 + 分批执行
- 通知漏发：
  - 启动时拉取状态补偿
- KPI 统计延迟：
  - 日批失败自动重跑 + 告警

## 9. 冻结规则

- Sprint4 不新增业务功能，仅做上线闭环
- 不扩展 AI 助手、社区等非 MVP 能力
- 仅修复阻断和高风险问题

## 10. 关联文档

- `docs/couple-planet/mvp-prd-v1.md`
- `docs/couple-planet/mvp-delivery-backlog-v1.md`
- `docs/couple-planet/relationship-unbind-policy.md`

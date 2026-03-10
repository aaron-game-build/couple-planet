# couple-planet

情侣星球工程目录（个人开发版，轻量 Monorepo）。

## 开发入口

在 `@couple-planet/` 目录执行：

```bash
pnpm install
pnpm dev:api
```

移动端：

```bash
cd apps/mobile
flutter pub get
flutter run
```

## 关键目录

- `apps/api`：NestJS 后端（Week1 主链路）
- `apps/mobile`：Flutter 客户端
- `packages/shared-types`：共享错误码与类型
- `packages/config`：通用配置占位
- `docs/couple-planet`：产品与研发文档全集

## Week1 每日执行顺序

1. `docs/couple-planet/personal-dev-week1-taskboard.md`
2. `docs/couple-planet/week1-api-contract.md`
3. `docs/couple-planet/week1-ddl.sql`
4. `docs/couple-planet/week1-nestjs-modules.md`
5. `docs/couple-planet/week1-day6-day7-acceptance.md`
6. `docs/couple-planet/week1-api-verification.md`

## Week1 目标（最小闭环）

- 注册/登录
- 邀请码绑定
- 即时消息发送/拉取/已读

Go 条件：

- 两个账号可稳定完成注册、绑定、互发消息
- 即时消息发送成功率 >= 99%
- 无 P0 阻断问题

## 当前工程状态

- 工程骨架已完成并与上层 agentic 框架隔离
- Week1 后端可运行化代码已落位到 `apps/api/src`
- 下一步优先：本地数据库拉起 + 跑 `week1-api-verification.md` 联调脚本

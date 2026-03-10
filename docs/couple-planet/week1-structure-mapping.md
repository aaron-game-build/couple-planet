# Week1 规划到工程结构映射

## 1) API 契约落位

- 契约文档：`docs/couple-planet/week1-api-contract.md`
- 后端模块入口：
  - `apps/api/src/modules/auth`
  - `apps/api/src/modules/relation`
  - `apps/api/src/modules/chat`
- 共享错误码：`packages/shared-types/src/index.ts`

## 2) DDL 与迁移落位

- 设计稿：`docs/couple-planet/week1-ddl.sql`
- 执行迁移：`apps/api/database/migrations/0001_week1_core.sql`

## 3) 模块职责落位

- 模块职责文档：`docs/couple-planet/week1-nestjs-modules.md`
- API 端落位索引：`apps/api/src/modules/README.md`

## 4) 前端页面映射

- `LoginPage` -> `apps/mobile/lib/features/auth`
- `BindPage` -> `apps/mobile/lib/features/relation`
- `ChatPage` -> `apps/mobile/lib/features/chat`

## 5) 联调与验收映射

- 执行脚本：`docs/couple-planet/week1-day6-day7-acceptance.md`
- 联调对象：
  - `apps/api` 接口与错误码
  - `apps/mobile` 页面与状态流

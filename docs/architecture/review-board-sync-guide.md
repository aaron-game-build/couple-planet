# 架构评审板同步指南（draw.io / Miro）
> EN: Architecture Review Board Sync Guide

目标：将仓库图源与外部评审板保持一致，确保“仓库图源优先”。

## 1）同步对象

- 系统上下文图：`docs/architecture/system-context.mmd`
- 模块关系图：`docs/architecture/mobile-backend-modules.puml`

## 2）同步规则（必须）

1. 先改仓库图源，再改外部评审板。
2. 外部评审板仅用于评审沟通，不作为真实来源（Source of Truth）。
3. 每次同步必须留一条同步记录（见第 5 节模板）。

## 3）建议同步流程

1. 修改仓库图源（`.mmd`/`.puml`）
2. 在本地生成图片（如 `PNG` 或 `SVG`）
3. 上传到 draw.io/Miro 对应画板
4. 在画板卡片中附图源路径与更新时间
5. 记录同步日志

## 4）命名规范

- 评审板页面命名：
  - `CP_SystemContext`
  - `CP_MobileBackendModules`
- 图文件命名：
  - `system-context_YYYYMMDD`
  - `mobile-backend-modules_YYYYMMDD`

## 5）同步日志模板（可复制）

```md
## Sync Record
- Date: YYYY-MM-DD
- Synced By: <name>
- Source Files:
  - docs/architecture/system-context.mmd
  - docs/architecture/mobile-backend-modules.puml
- Board Target:
  - draw.io / Miro URL
- Changes:
  - <what changed>
- Verification:
  - [ ] board labels updated
  - [ ] source paths attached
  - [ ] reviewer notified
```

## 6）评审前检查项

- 图中术语与当前代码一致（如 `ApiClient`、`RelationService`）
- 新增模块已出现在图中
- 已废弃模块已从图中移除
- 评审板版本标记日期不早于最近一次代码改动

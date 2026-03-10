# Release Evidence Governance
> EN: Release Evidence Governance

## 1）目录约定

- 历史快照：`docs/release/evidence/<timestamp>`
- 最新镜像：`docs/release/evidence/latest`
- 最新指针：`docs/release/evidence/LATEST.md`

## 2）归档方式

- 统一使用脚本：`bash scripts/release/archive-preupload-evidence.sh`
- 每次归档会：
  - 生成新的时间戳目录
  - 刷新 `latest` 目录为当前快照镜像
  - 更新 `LATEST.md` 指针

## 3）引用规则

- 对外报告（go/no-go、release checklist）优先引用 `latest`。
- 审计追溯场景引用具体 `<timestamp>` 目录。

## 4）Notion 同步建议

- `Release & Regression` 页面固定维护两类链接：
  - Latest evidence: `docs/release/evidence/latest`
  - Audit snapshots: `docs/release/evidence/<timestamp>`

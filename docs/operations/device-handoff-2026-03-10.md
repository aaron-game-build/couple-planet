# 设备切换接力文档（2026-03-10）
> EN: Device Handoff Notes

本文用于在新设备上无缝继续 Couple Planet 当前执行进度。

## 1）当前状态（已完成）

### 代码与仓库

- 代码仓库已初始化并推送到远端：
  - `git@github.com:aaron-game-build/couple-planet.git`
- 当前主分支：`main`
- 关键执行化成果已入库（云上、发布、工作流文档与脚本）。

### 已落地能力

- Figma 外部执行包：
  - `docs/couple-planet/figma-bootstrap-pack.md`
- 架构评审板同步规范：
  - `docs/architecture/review-board-sync-guide.md`
- cloud-dev 启动与运维脚本：
  - `scripts/cloud/bootstrap-cloud-dev.sh`
  - `scripts/ops/db-backup.sh`
  - `scripts/ops/db-restore.sh`
- 云上容器编排：
  - `docker-compose.cloud.dev.yml`
  - `apps/api/Dockerfile`
  - `.env.cloud.dev.example`
- 发布与决策文档：
  - `docs/release/testflight-dry-run-latest.md`
  - `docs/release/go-no-go-latest.md`
  - `docs/release/testflight-preupload-checklist-v1.md`

### 已验证结果

- iOS dry-run 通过：
  - `flutter analyze` PASS
  - `flutter test` PASS
  - `flutter build ios --release --no-codesign` PASS
- cloud-dev 实操记录已生成：
  - `docs/operations/cloud-dev-execution-round-001.md`
  - `docs/operations/cloud-dev-execution-round-002.md`（PASS）

## 2）当前阻塞

- 阻塞项：无（cloud-dev 已打通）。
- 当前限制：
  - 真实 TestFlight 上传仍依赖 macOS + Xcode Organizer + Apple 账号权限。
  - 移动端人工回归（路由分流/账号切换）需要真机或模拟器执行并补证据。

## 3）新设备接续步骤（建议按顺序）

### Step A：环境准备

1. 安装并确认：
   - Git
   - Node.js（含 corepack）
   - pnpm（通过 corepack）
   - Flutter
   - Docker Engine + Docker Compose Plugin
2. 配置 GitHub SSH key（确保可推送）。

### Step B：拉取与依赖

```bash
git clone git@github.com:aaron-game-build/couple-planet.git
cd couple-planet/@couple-planet
corepack enable
corepack prepare pnpm@10.6.0 --activate
pnpm install
```

### Step C：拉起 cloud-dev（优先）

```bash
cp .env.cloud.dev.example .env.cloud.dev
bash scripts/cloud/bootstrap-cloud-dev.sh
curl http://localhost:3000/api/v1/health
```

通过标准：
- 健康检查返回 `status: ok` 且 `db: up`

### Step D：更新发布前检查清单

完成 cloud-dev 后，更新并勾选：
- `docs/release/testflight-preupload-checklist-v1.md` 中 cloud-dev 项

### Step E：真实 TestFlight 上传

1. 按 `docs/release/ios-testflight-flow.md` 执行签名与上传。
2. 回填结果到：
   - `docs/release/testflight-preupload-checklist-v1.md`
   - `docs/release/go-no-go-latest.md`

## 4）后续建议（优先级）

1. **P0**：补齐业务回归证据（登录/绑定/聊天/账号切换）。
2. **P1**：完成真实 TestFlight 上传并记录构建号与发布说明。
3. **P1**：在 draw.io/Miro 完成一次图源同步并留同步日志。
4. **P2**：将发布闸口证据采集逐步脚本化，减少人工回填。

## 5）建议提交策略（新设备）

- 每个里程碑 1 个 commit（避免超大提交）：
  1. `cloud-dev bootstrap success`
  2. `testflight preupload checklist update`
  3. `release gate update`
- commit 后立即 `git push`，确保多设备进度一致。

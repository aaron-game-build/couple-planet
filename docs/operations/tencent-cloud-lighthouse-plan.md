# 腾讯云 Lighthouse + Docker 开发计划
> EN: Tencent Cloud Lighthouse + Docker Plan

本文定义 Couple Planet 在腾讯云上的开发与预发布能力建设方案。

## 1）范围与目标

- 主路线：腾讯云 Lighthouse + Docker Compose
- 保持个人开发场景下的低运维复杂度
- 支持：
  - 可长期在线的 API 环境
  - 远程联调与集成验证
  - iOS 测试前的云上预发布验证

## 2）环境分层策略

- `local-dev`：本地开发，最快反馈
- `cloud-dev`：Lighthouse 开发环境，远程联调与共享测试
- `cloud-staging`：预发布验证环境（可先逻辑隔离，再物理隔离）

## 3）Lighthouse 基线配置

- 系统：Ubuntu LTS
- 安全：
  - 仅允许 SSH 密钥登录
  - 安全组仅开放必要端口
  - API 通过反向代理暴露，避免直接暴露容器端口
- 运行时：
  - Docker Engine
  - Docker Compose
  - 可选 Nginx 容器（反代与 HTTPS）

## 4）推荐容器拓扑

- `api`：NestJS 服务
- `postgres`：数据库
- `nginx`（可选）：反向代理/TLS

## 5）配置约定

- `.env.local`
- `.env.cloud.dev`
- `.env.cloud.staging`

约束：
- 敏感信息不入仓库
- 使用云端环境变量或安全存储
- 环境变量键名在不同环境保持一致

## 6）初始化步骤

1. 创建 Lighthouse 实例并绑定固定公网 IP
2. 完成 SSH 与系统安全基线
3. 安装 Docker 与 Compose
4. 拉取仓库并准备 `.env.cloud.dev`
5. 启动 Compose 并验证 API 健康检查
6. 增加日志采集与滚动策略
7. 增加数据库备份/恢复脚本

## 7）运维操作手册

- 启动服务：
  - `docker compose up -d`
- 健康检查：
  - `curl http://<host>/api/v1/health`
- 查看日志：
  - `docker compose logs -f api`
- 数据库备份：
  - 使用 `pg_dump` 输出时间戳备份文件
- 数据库恢复：
  - 使用 `psql` 从指定备份恢复

## 8）环境晋升策略

- 先部署到 `cloud-dev`
- 执行回归清单并记录结果
- 使用同一镜像/tag 晋升到 `cloud-staging`
- 完成发布前检查后再进入 TestFlight 测试

## 9）术语对照（Terminology）

- 开发环境：Development Environment
- 预发布环境：Staging Environment
- 容器拓扑：Container Topology
- 运维手册：Operational Runbook
- 环境晋升：Promotion Policy

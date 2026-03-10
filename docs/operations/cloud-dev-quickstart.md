# cloud-dev 快速启动（Lighthouse）
> EN: cloud-dev Quickstart

## 1）准备

在云主机拉取代码后，确认：

- 已安装 Docker Engine 与 Docker Compose
- 当前用户有 Docker 运行权限

## 2）启动

在仓库根目录执行：

```bash
cp .env.cloud.dev.example .env.cloud.dev
bash scripts/cloud/bootstrap-cloud-dev.sh
```

## 3）验证

- API 健康检查：
  - `curl http://localhost:3000/api/v1/health`
- 查看容器状态：
  - `docker compose --env-file .env.cloud.dev -f docker-compose.cloud.dev.yml ps`
- 查看 API 日志：
  - `docker compose --env-file .env.cloud.dev -f docker-compose.cloud.dev.yml logs -f api`

## 4）停止

```bash
docker compose --env-file .env.cloud.dev -f docker-compose.cloud.dev.yml down
```

如需清理数据库卷（危险操作）：

```bash
docker compose --env-file .env.cloud.dev -f docker-compose.cloud.dev.yml down -v
```

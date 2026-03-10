# cloud-dev 运维基线（日志/备份/恢复）
> EN: cloud-dev Ops Baseline

## 1）日志滚动策略（已落地）

`docker-compose.cloud.dev.yml` 已配置 `json-file` 日志滚动：

- `max-size: 10m`
- `max-file: 3`

验证命令：

```bash
docker inspect couple-planet-api --format '{{json .HostConfig.LogConfig}}'
docker inspect couple-planet-postgres --format '{{json .HostConfig.LogConfig}}'
```

## 2）数据库备份

```bash
bash scripts/ops/db-backup.sh
```

输出位置：

- `backups/couple_planet_YYYYMMDD_HHMMSS.sql`

## 3）数据库恢复

```bash
bash scripts/ops/db-restore.sh backups/<your_backup_file>.sql
```

## 4）恢复演练模板（每周至少一次）

1. 执行备份脚本
2. 在测试库/当前 cloud-dev 进行恢复
3. 运行健康检查：
   - `curl http://localhost:3000/api/v1/health`
4. 登录并拉取消息验证核心数据
5. 记录演练结果（日期、备份文件、恢复结果、异常）

## 5）故障应急最小动作

1. 看 API 日志：
   - `docker compose --env-file .env.cloud.dev -f docker-compose.cloud.dev.yml logs -f api`
2. 看 DB 状态：
   - `docker compose --env-file .env.cloud.dev -f docker-compose.cloud.dev.yml ps`
3. 若数据损坏，按最近一次备份执行恢复

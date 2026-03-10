# Preupload CI 验证记录（2026-03-10）
> EN: Preupload CI Validation Record

## 1）目标

- 验证 `.github/workflows/preupload-ci.yml` 覆盖项是否与发布前闸口一致：
  - API Guardrails（Node + pnpm + `@couple-planet/api` build）
  - iOS Dry Run（Flutter analyze/test/build-no-codesign）

## 2）本地等价验证

### 2.1 API Guardrails

- Command:
  - `pnpm --filter @couple-planet/api build`
- Result: PASS

### 2.2 iOS Dry Run

- Command:
  - `bash scripts/release/testflight-dry-run.sh`
- Result: FAIL
- Error: `flutter: command not found`

## 3）远端触发状态

- `gh auth status`: not logged in
- 当前会话无法直接调用 GitHub Actions 触发远端 workflow。

## 4）结论与下一步

- 结论：workflow 内容与发布流程一致，本地已验证 API 链路可用。
- 下一步：在已登录 GitHub 的发布机执行：
  - `gh workflow run preupload-ci.yml`
  - `gh run list --workflow preupload-ci.yml --limit 1`
  - 将 run URL 回填到本文件。

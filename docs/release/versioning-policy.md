# 版本策略
> EN: Versioning Policy

## 1）应用版本号

- 格式：`major.minor.patch`（示例：`0.2.0`）
- `major`：破坏性变更或重大里程碑
- `minor`：新增用户可见功能
- `patch`：缺陷修复与稳定性更新

## 2）构建号

- 每次 TestFlight 上传必须递增
- 构建号在 App Store Connect 中必须保持单调递增

## 3）标签建议

- 发布提交建议使用：
  - `mobile-v<major.minor.patch>+<build>`
  - 示例：`mobile-v0.2.0+18`

## 4）变更日志最小结构

- Added（新增）
- Changed（变更）
- Fixed（修复）
- Known issues（已知问题）

## 5）术语对照（Terminology）

- 应用版本号：App Version
- 构建号：Build Number
- 标签：Tagging
- 变更日志：Change Log

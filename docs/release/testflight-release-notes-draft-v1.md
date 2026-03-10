# TestFlight 发布说明草稿 v1
> EN: TestFlight Release Notes Draft v1

- Date: 2026-03-10
- Target: Couple Planet iOS Internal Testing
- Build: TBD（待 Xcode Organizer 上传后回填）

## 1）主要变化

- 打通核心闭环：注册 -> 登录 -> 绑定 -> 聊天。
- cloud-dev 环境已验证可启动，`/api/v1/health` 返回 `status=ok`、`db=up`。
- 修复并强化关系与聊天主链路的接口稳定性（含鉴权、绑定、消息读取）。

## 2）测试重点

1. 已绑定账号登录后是否直达聊天页。
2. 绑定/解绑流程是否稳定，异常码是否符合预期。
3. 聊天发送、拉取、已读状态是否一致。
4. 多账号切换后路由和会话状态是否正确恢复。

## 3）已知限制

- 真实 TestFlight 上传需在 macOS + Xcode Organizer 环境完成。
- 本轮部分移动端人工回归项待在真机或模拟器补证据。

## 4）测试账号（待回填）

- Account A: TBD
- Account B: TBD

## 5）回滚策略

- 若出现 P0/P1 阻断问题，暂停该 build 的测试并回退到上一个可用 TestFlight 版本。

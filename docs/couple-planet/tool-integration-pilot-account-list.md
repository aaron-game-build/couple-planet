# 工具接入样板链路（Pilot）- Account List MVP
> 目标：用 1 条已入库需求跑通 Stitch -> Figma -> 架构图 -> 开发 -> 回归 的完整闭环。

## 0）样板范围

- Pilot Feature：`账号列表（免重复登录）MVP`
- 需求真源：`docs/couple-planet/account-list-mvp.md`
- 适用流程：`docs/couple-planet/ui-workflow.md`
- 模板来源：`docs/couple-planet/couple-planet-feature-workflow-template.md`

## 1）Notion 卡片初始化（先建再做）

### 1.1 PRD / Requirements

- Title：`[Account] SavedAccountSwitcherMVP`
- Status：`Approved / 已通过`
- Stitch Options Link：`<to-fill>`
- Figma Frame URL：`<to-fill>`
- Figma Frame ID：`<to-fill>`
- Architecture Decision Link：`<to-fill>`
- Architecture Diagram Path：`docs/architecture/system-context.mmd`
- Acceptance Criteria：引用 `docs/couple-planet/account-list-mvp.md`
- Input Package Ready：`false`（待 Phase B-D 完成后改为 `true`）

### 1.2 Dev Tasks

- Task Title：`[Account] SavedListUIAndTokenSwitch`
- Module：`mobile`
- Requirement Link：关联上面 PRD
- API Contract Link：`docs/couple-planet/week1-api-contract.md`
- Architecture Diagram Path：`docs/architecture/system-context.mmd`
- Acceptance Checklist：引用本文第 6 节
- Gate Result：`Blocked`

### 1.3 Release & Regression

- Version：`0.2.x`
- Build Version：`<to-fill>`
- Go No-Go：`No-Go`（默认）
- P0 P1 Summary：`<to-fill>`
- Evidence Bundle：`<to-fill>`
- Linked Dev Tasks：关联上面 Dev Task

## 2）Phase A - Stitch（30 分钟内）

输出 2-3 个候选并在 Notion 记录保留/放弃理由：

- Option A：登录页列表 + 最近使用排序（基础版）
- Option B：分组列表（可用/需重登）
- Option C：带快捷搜索（可选）

决策模板（写入 `Architecture Decisions`）：

- Context：账号切换降低重复登录成本
- Decision：采用 Option B（可用/需重登分组清晰）
- Consequences：需要补 `needsRelogin` 状态说明与 UI 标识
- Diagram Source Path：`docs/architecture/system-context.mmd`

门禁：

- 未写明“放弃方案原因”不得进入 Phase B。

## 3）Phase B - Figma（状态冻结）

页面命名按 `Feature_Screen_State`：

- `Account_Login_Default`
- `Account_Login_Loading`
- `Account_Login_Empty`
- `Account_Login_Error`
- `Account_Login_ReadOnly`

交互说明必须包含：

- 点击账号 -> token 设置 -> `auth/me` 校验 -> Chat/Bind 分流
- token 失效 -> 标记 `needsRelogin=true` -> 引导重新登录
- 删除单个账号 / 清空全部账号的确认与回退提示

门禁：

- 五个状态缺任意一个，`Input Package Ready` 不得勾选。

## 4）Phase C-D - 评审板与仓库图源同步

1. 先更新仓库图源（Mermaid/PlantUML）：
   - `docs/architecture/system-context.mmd`
   - `docs/architecture/mobile-backend-modules.puml`
2. 再同步到 draw.io/Miro 评审板（外部沟通用）。
3. 在 Notion 的 `Architecture Decisions` 记录同步日期、影响范围、Owner。

门禁：

- 仅更新 draw.io/Miro 未更新仓库图源，Dev Task 必须维持 `Blocked`。

## 5）Phase E - Cursor + Flutter/NestJS 实现

### 5.1 输入包核对（全部通过后才能开发）

- [ ] PRD Link 已关联且验收标准完整
- [ ] Figma Frame URL + Frame ID 已填写
- [ ] 架构图路径已填写且图源已更新
- [ ] API Contract Link 已绑定
- [ ] 关键状态截图已附（default/loading/empty/error/readOnly）

通过后：

- `Input Package Ready` -> `true`
- `Dev Task.Gate Result` -> `Ready`

### 5.2 实现建议（最小切片）

- Mobile：
  - 账号列表存储与排序（`lastUsedAt`）
  - 切换校验与 `needsRelogin` 标记
  - 删除单个/清空全部
- API：
  - 复用 `auth/me` 校验流程
  - 明确失效 token 错误返回与提示策略

## 6）回归与发布证据（DoD）

### 6.1 回归项

- [ ] 登录过账号可见且按最近使用排序
- [ ] 有效账号点击后可免密进入业务流
- [ ] 失效账号会提示并标记需重登
- [ ] 删除/清空后账号不再可切换
- [ ] 切换账号后无身份串号

### 6.2 发布门禁

- [ ] `flutter analyze` 通过
- [ ] 关键链路人工回归通过
- [ ] `Release & Regression` 已填写 `Go No-Go`、`P0 P1 Summary`
- [ ] `Evidence Bundle` 已附截图/日志/测试记录

满足后才可将：

- `Dev Task.Status` 标记为 `Done`
- `Release & Regression.Go No-Go` 改为 `Go`

## 7）复用说明（复制到下一条需求）

复制本文件并替换以下内容即可复用：

- Pilot Feature 名称
- PRD/Dev Task/Release 标题
- Figma 页面命名
- 架构图源路径
- 回归清单中的业务断言

# Notion 数据库与视图模板
> EN: Notion Databases and Views Template

使用本模板搭建外部项目控制中心。

## 1）数据库

### PRD / 需求库

字段：
- Title（标题）
- Status（`Draft`、`Review`、`Approved`、`In Dev`、`Done`）
- Priority（优先级）
- Figma Link
- Architecture Link
- Acceptance Criteria（验收标准）
- Related Dev Tasks（关联开发任务）

### Architecture Decisions（架构决策库）

字段：
- Decision ID（决策编号）
- Title（标题）
- Context（背景）
- Decision（决策）
- Consequences（影响）
- Diagram Source Path（图源路径）
- Related PRD（关联需求）

### Design Tasks（设计任务库）

字段：
- Task Title（任务标题）
- Feature（所属功能）
- Figma Frame IDs
- State Coverage（`default/loading/empty/error/readOnly`）
- Status（状态）
- Owner（负责人）
- Due Date（截止日期）

### Dev Tasks（研发任务库）

字段：
- Task Title（任务标题）
- Module（`mobile`、`api`、`docs`、`ops`）
- PRD Link
- Acceptance Checklist（验收清单）
- Status（状态）
- Owner（负责人）
- Related Release（关联发布）

### Release & Regression（发布与回归库）

字段：
- Version（版本）
- Build Number（构建号）
- Environment（环境）
- Checklist Result（清单结果）
- Evidence Links（证据链接）
- Decision（`Go`/`No-Go`）

## 2）推荐视图

- 按状态看板（PRD 与 Dev Tasks）
- 日历视图（Design 与 Release）
- 发布历史表格视图
- 高优先级筛选视图

## 3）英文术语对照（English Terms）

- 需求库：Requirements Database
- 架构决策库：Architecture Decisions
- 设计任务库：Design Tasks
- 研发任务库：Development Tasks
- 发布与回归库：Release and Regression
- 验收标准：Acceptance Criteria

## 4）Notion 字段双语命名规范（可直接复制）

命名格式建议统一为：`English / 中文`。  
示例：`Status / 状态`、`Acceptance Criteria / 验收标准`。

### 4.1 PRD / 需求库（Requirements）

- `Title / 标题`
- `Status / 状态`
- `Priority / 优先级`
- `Figma Link / Figma 链接`
- `Architecture Link / 架构链接`
- `Acceptance Criteria / 验收标准`
- `Related Dev Tasks / 关联开发任务`

### 4.2 Architecture Decisions / 架构决策库

- `Decision ID / 决策编号`
- `Title / 标题`
- `Context / 背景`
- `Decision / 决策`
- `Consequences / 影响`
- `Diagram Source Path / 图源路径`
- `Related PRD / 关联需求`

### 4.3 Design Tasks / 设计任务库

- `Task Title / 任务标题`
- `Feature / 所属功能`
- `Figma Frame IDs / Figma 页面ID`
- `State Coverage / 状态覆盖`
- `Status / 状态`
- `Owner / 负责人`
- `Due Date / 截止日期`

### 4.4 Dev Tasks / 研发任务库

- `Task Title / 任务标题`
- `Module / 模块`
- `PRD Link / PRD 链接`
- `Acceptance Checklist / 验收清单`
- `Status / 状态`
- `Owner / 负责人`
- `Related Release / 关联发布`

### 4.5 Release & Regression / 发布与回归库

- `Version / 版本`
- `Build Number / 构建号`
- `Environment / 环境`
- `Checklist Result / 清单结果`
- `Evidence Links / 证据链接`
- `Decision / 发布决策`

### 4.6 推荐状态枚举（Status Options）

- `Draft / 草稿`
- `Review / 评审中`
- `Approved / 已通过`
- `In Progress / 开发中`
- `Blocked / 阻塞`
- `Done / 已完成`

## 5）字段类型建议（Property Type）

说明：以下类型为 Notion 推荐配置，优先保证跨库可关联与可筛选。

### 5.1 PRD / 需求库

- `Title / 标题`：Title
- `Status / 状态`：Select
- `Priority / 优先级`：Select
- `Figma Link / Figma 链接`：URL
- `Architecture Link / 架构链接`：URL
- `Acceptance Criteria / 验收标准`：Text
- `Related Dev Tasks / 关联开发任务`：Relation -> `Dev Tasks`

### 5.2 Architecture Decisions / 架构决策库

- `Decision ID / 决策编号`：Text
- `Title / 标题`：Title
- `Context / 背景`：Text
- `Decision / 决策`：Text
- `Consequences / 影响`：Text
- `Diagram Source Path / 图源路径`：Text
- `Related PRD / 关联需求`：Relation -> `PRD / Requirements`

### 5.3 Design Tasks / 设计任务库

- `Task Title / 任务标题`：Title
- `Feature / 所属功能`：Select
- `Figma Frame IDs / Figma 页面ID`：Text
- `State Coverage / 状态覆盖`：Multi-select
- `Status / 状态`：Select
- `Owner / 负责人`：People
- `Due Date / 截止日期`：Date

### 5.4 Dev Tasks / 研发任务库

- `Task Title / 任务标题`：Title
- `Module / 模块`：Select
- `PRD Link / PRD 链接`：Relation -> `PRD / Requirements`
- `Acceptance Checklist / 验收清单`：Text
- `Status / 状态`：Select
- `Owner / 负责人`：People
- `Related Release / 关联发布`：Relation -> `Release & Regression`

### 5.5 Release & Regression / 发布与回归库

- `Version / 版本`：Title
- `Build Number / 构建号`：Number
- `Environment / 环境`：Select
- `Checklist Result / 清单结果`：Select
- `Evidence Links / 证据链接`：URL
- `Decision / 发布决策`：Select

## 6）字段必填级别（MUST / SHOULD）

说明：
- MUST：创建卡片时必须填写
- SHOULD：建议在进入执行阶段前补齐

### 6.1 PRD / 需求库

- MUST：`Title / 标题`、`Status / 状态`、`Priority / 优先级`、`Acceptance Criteria / 验收标准`
- SHOULD：`Figma Link / Figma 链接`、`Architecture Link / 架构链接`、`Related Dev Tasks / 关联开发任务`

### 6.2 Architecture Decisions / 架构决策库

- MUST：`Decision ID / 决策编号`、`Title / 标题`、`Context / 背景`、`Decision / 决策`
- SHOULD：`Consequences / 影响`、`Diagram Source Path / 图源路径`、`Related PRD / 关联需求`

### 6.3 Design Tasks / 设计任务库

- MUST：`Task Title / 任务标题`、`Feature / 所属功能`、`Status / 状态`
- SHOULD：`Figma Frame IDs / Figma 页面ID`、`State Coverage / 状态覆盖`、`Owner / 负责人`、`Due Date / 截止日期`

### 6.4 Dev Tasks / 研发任务库

- MUST：`Task Title / 任务标题`、`Module / 模块`、`Status / 状态`、`Acceptance Checklist / 验收清单`
- SHOULD：`PRD Link / PRD 链接`、`Owner / 负责人`、`Related Release / 关联发布`

### 6.5 Release & Regression / 发布与回归库

- MUST：`Version / 版本`、`Build Number / 构建号`、`Environment / 环境`、`Decision / 发布决策`
- SHOULD：`Checklist Result / 清单结果`、`Evidence Links / 证据链接`

## 7）一键建库顺序与 Relation 配置

### 7.1 推荐建库顺序

1. `PRD / Requirements`
2. `Dev Tasks`
3. `Release & Regression`
4. `Architecture Decisions`
5. `Design Tasks`

### 7.2 Relation 配置步骤（最少集）

1. 在 `Dev Tasks` 创建 `PRD Link / PRD 链接`，关联到 `PRD / Requirements`
2. 在 `PRD / Requirements` 创建 `Related Dev Tasks / 关联开发任务`（与上一步互为双向）
3. 在 `Dev Tasks` 创建 `Related Release / 关联发布`，关联到 `Release & Regression`
4. 在 `Architecture Decisions` 创建 `Related PRD / 关联需求`，关联到 `PRD / Requirements`

### 7.3 落地建议

- 先创建最小字段集（MUST），当天即可投入使用
- 第二轮再补 SHOULD 字段与视图优化
- 每周固定 1 次清理 `Blocked / 阻塞` 与无主任务

## 8）Notion 视图预设清单（开箱即用）

说明：以下为每个数据库建议的最小视图集，按此配置即可满足日常管理。

### 8.1 PRD / 需求库（Requirements）

- `Board - By Status / 按状态看板`
  - 分组：`Status / 状态`
  - 过滤：`Status / 状态` is not `Done / 已完成`
- `Table - Priority Queue / 优先级队列`
  - 排序：`Priority / 优先级`（高 -> 低）
  - 过滤：`Status / 状态` is any of `Draft / 草稿`, `Review / 评审中`, `Approved / 已通过`
- `Table - Missing Links / 待补链接`
  - 过滤：`Figma Link / Figma 链接` is empty OR `Architecture Link / 架构链接` is empty

### 8.2 Architecture Decisions / 架构决策库

- `Table - Decision Log / 决策日志`
  - 排序：`Decision ID / 决策编号`（降序）
- `Table - Pending Impact / 待补影响分析`
  - 过滤：`Consequences / 影响` is empty
- `Table - Unlinked PRD / 未关联需求`
  - 过滤：`Related PRD / 关联需求` is empty

### 8.3 Design Tasks / 设计任务库

- `Board - By Status / 按状态看板`
  - 分组：`Status / 状态`
  - 过滤：`Status / 状态` is not `Done / 已完成`
- `Calendar - Due Date / 截止日期日历`
  - 日期字段：`Due Date / 截止日期`
- `Table - Missing State Coverage / 状态覆盖缺失`
  - 过滤：`State Coverage / 状态覆盖` is empty

### 8.4 Dev Tasks / 研发任务库

- `Board - Sprint Board / 冲刺看板`
  - 分组：`Status / 状态`
  - 过滤：`Status / 状态` is not `Done / 已完成`
- `Table - Blocked / 阻塞任务`
  - 过滤：`Status / 状态` is `Blocked / 阻塞`
- `Table - Unlinked PRD / 未关联需求`
  - 过滤：`PRD Link / PRD 链接` is empty
- `Table - This Week / 本周任务`
  - 过滤：`Status / 状态` is any of `In Progress / 开发中`, `Review / 评审中`

### 8.5 Release & Regression / 发布与回归库

- `Table - Release History / 发布历史`
  - 排序：`Build Number / 构建号`（降序）
- `Table - Go/No-Go Gate / 发布闸口`
  - 过滤：`Decision / 发布决策` is any of `Go`, `No-Go`
- `Table - Missing Evidence / 缺少证据`
  - 过滤：`Evidence Links / 证据链接` is empty
- `Board - By Environment / 按环境`
  - 分组：`Environment / 环境`

### 8.6 全局联动视图（可选）

- `My Open Tasks / 我的进行中任务`
  - 来源：`Design Tasks` + `Dev Tasks`（分别建同名视图）
  - 过滤：`Owner / 负责人` contains `Me` AND `Status / 状态` is not `Done / 已完成`
- `Weekly Ops / 周运营面板`
  - 来源：`PRD / Requirements`、`Dev Tasks`、`Release & Regression`
  - 目标：每周例会快速查看需求进度、阻塞项、发布闸口状态

## 9）1 小时快速搭建手册（60 min）

目标：在 60 分钟内完成可用的 Notion 项目控制台（含 5 库、核心关系、关键视图、样例数据）。

### 0-10 分钟：创建 5 个数据库

1. 新建页面：`Couple Planet Workspace / 工作台`
2. 按以下顺序创建数据库（Table 即可）：
   - `PRD / Requirements`
   - `Dev Tasks`
   - `Release & Regression`
   - `Architecture Decisions`
   - `Design Tasks`
3. 每个库先只保留默认标题列，其他字段下一步再加

验收点：
- 5 个数据库已创建
- 名称与顺序正确

### 10-25 分钟：补齐 MUST 字段

按本文件「6）字段必填级别」先补 MUST 字段，不做 SHOULD。

优先级建议：
1. `PRD / Requirements`：`Status / 状态`、`Priority / 优先级`、`Acceptance Criteria / 验收标准`
2. `Dev Tasks`：`Module / 模块`、`Status / 状态`、`Acceptance Checklist / 验收清单`
3. `Release & Regression`：`Build Number / 构建号`、`Environment / 环境`、`Decision / 发布决策`
4. `Architecture Decisions`：`Decision ID / 决策编号`、`Context / 背景`、`Decision / 决策`
5. `Design Tasks`：`Feature / 所属功能`、`Status / 状态`

验收点：
- 5 个库的 MUST 字段都已存在
- 字段类型与「5）字段类型建议」一致

### 25-35 分钟：配置最少 Relation

按「7.2 Relation 配置步骤（最少集）」完成 4 条关联：
1. `Dev Tasks`.`PRD Link / PRD 链接` -> `PRD / Requirements`
2. `PRD / Requirements`.`Related Dev Tasks / 关联开发任务`（双向自动出现）
3. `Dev Tasks`.`Related Release / 关联发布` -> `Release & Regression`
4. `Architecture Decisions`.`Related PRD / 关联需求` -> `PRD / Requirements`

验收点：
- 在 `Dev Tasks` 里可以选中一条 PRD
- 在 PRD 卡片中能反向看到关联 Dev Task

### 35-50 分钟：创建关键视图（最小集）

先做每库 1-2 个核心视图：

- `PRD / Requirements`
  - `Board - By Status / 按状态看板`
  - `Table - Missing Links / 待补链接`
- `Dev Tasks`
  - `Board - Sprint Board / 冲刺看板`
  - `Table - Blocked / 阻塞任务`
- `Release & Regression`
  - `Table - Release History / 发布历史`
  - `Table - Missing Evidence / 缺少证据`
- `Architecture Decisions`
  - `Table - Decision Log / 决策日志`
- `Design Tasks`
  - `Board - By Status / 按状态看板`

验收点：
- 至少创建 8 个视图
- 过滤条件可正确筛出空字段或阻塞项

### 50-60 分钟：填充样例数据并试跑

每个库至少新增 1 条示例：

- `PRD / Requirements`
  - `Title / 标题`：`[Chat] 历史会话只读`
  - `Status / 状态`：`Approved / 已通过`
- `Dev Tasks`
  - `Task Title / 任务标题`：`[Chat] 只读模式 UI 与发送禁用`
  - 关联上面的 PRD
- `Release & Regression`
  - `Version / 版本`：`0.2.0`
  - `Decision / 发布决策`：`Go`
- `Architecture Decisions`
  - `Decision ID / 决策编号`：`ADR-001`
- `Design Tasks`
  - `Task Title / 任务标题`：`[Chat] ReadOnly 状态页面定稿`

最后执行 3 个检查：
1. `Missing Links` 是否能看到待补字段
2. `Blocked` 视图是否为空（初始可为空）
3. PRD 与 Dev Task 的双向关联是否可见

## 10）首次上线后的周节奏（建议）

- 周一：补齐本周 PRD 与 Design Tasks
- 周三：清理 `Blocked / 阻塞` 与无主任务
- 周五：更新 `Release & Regression` 并沉淀证据链接

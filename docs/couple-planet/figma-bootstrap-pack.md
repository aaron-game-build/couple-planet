# Figma 启动执行包（Notion 之外）
> EN: Figma Bootstrap Pack (Outside Notion)

本文件用于在 Figma 内快速完成第一批可交付设计资产，避免仅靠口头沟通推进。

## 1）页面骨架（必须先建）

按以下顺序创建页面：

1. `00_Foundation`
2. `01_Flows`
3. `02_Components`

## 2）`00_Foundation` 最小资产

- 颜色 Token：
  - `cp/bg/primary`
  - `cp/bg/surface`
  - `cp/text/primary`
  - `cp/text/secondary`
  - `cp/brand/pink`
  - `cp/status/error`
- 字体层级：
  - `cp/title/lg`
  - `cp/title/md`
  - `cp/body/md`
  - `cp/body/sm`
  - `cp/caption`
- 间距 Token：
  - `cp/space/4`
  - `cp/space/8`
  - `cp/space/12`
  - `cp/space/16`
  - `cp/space/24`

## 3）`01_Flows` 首批 Frame 清单

命名规则：`Feature_Screen_State`。

### Auth

- `Auth_Login_Default`
- `Auth_Login_Loading`
- `Auth_Login_Error`

### Relation

- `Relation_Bind_Default`
- `Relation_Bind_Loading`
- `Relation_Bind_Error`
- `Relation_Bind_Bound`

### Chat List

- `ChatList_Main_Default`
- `ChatList_Main_Empty`
- `ChatList_Main_Error`

### Chat

- `Chat_Main_Default`
- `Chat_Main_Loading`
- `Chat_Main_Empty`
- `Chat_Main_Error`
- `Chat_Main_ReadOnly`

## 4）`02_Components` 首批组件

- `CP/Button/Primary`
- `CP/Button/Secondary`
- `CP/Input/TextField`
- `CP/Chat/BubbleLeft`
- `CP/Chat/BubbleRight`
- `CP/Chat/Avatar`
- `CP/List/ConversationItem`
- `CP/State/Empty`
- `CP/State/Error`

## 5）每个 Frame 必须补齐的信息

- 页面标题与功能目的
- 入口/退出路径（从哪个页面来，点哪里离开）
- 交互说明（按钮点击、禁用态、重试）
- 文案边界（超长文本、空字段兜底）
- 状态说明（default/loading/empty/error/readOnly）

## 6）设计完成判定（DoD）

满足以下条件才算“可交付给开发”：

- 命名完全符合 `Feature_Screen_State`
- 流程主路径可串通（登录 -> 绑定 -> 聊天列表 -> 聊天页）
- 关键状态齐全（default/loading/empty/error/readOnly）
- 组件优先复用，不出现一次性硬编码样式
- 每个页面都能映射到实现模块（`apps/mobile` 对应页面）

## 7）建议执行顺序（90 分钟）

1. 先建页面骨架（10 分钟）
2. 建 Foundation token（20 分钟）
3. 先画主路径 default（30 分钟）
4. 补 empty/error/loading/readOnly（20 分钟）
5. 提炼组件并替换页面实例（10 分钟）

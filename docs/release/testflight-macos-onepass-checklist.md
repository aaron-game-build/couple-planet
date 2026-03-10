# TestFlight macOS 发布机一步过清单
> EN: TestFlight macOS One-pass Checklist

适用场景：在具备 Apple 账号权限的 macOS 发布机上，一次性完成构建、上传、回填和证据归档。

## 1）可复制命令

```bash
# ===== 0) 进入仓库 =====
cd /root/.openclaw/workspaces/mobile-app/couple-planet

# ===== 1) 发布机能力检查 =====
xcodebuild -version
flutter --version
git pull

# ===== 2) 安装依赖 =====
cd apps/mobile
flutter clean
flutter pub get

# ===== 3) 运行发布前 dry-run（推荐）=====
cd /root/.openclaw/workspaces/mobile-app/couple-planet
bash scripts/release/testflight-dry-run.sh

# ===== 4) 构建 iOS（含签名准备）=====
cd apps/mobile
flutter build ios --release

# ===== 5) Xcode 手工步骤（命令行不能替代）=====
# 1. open ios/Runner.xcworkspace
# 2. Product -> Archive
# 3. Organizer -> Distribute App -> App Store Connect -> Upload
# 4. 等待 App Store Connect processing 完成

# ===== 6) 回到仓库，归档证据 =====
cd /root/.openclaw/workspaces/mobile-app/couple-planet
bash scripts/release/archive-preupload-evidence.sh
```

## 2）每步成功判定

- 能力检查：`xcodebuild` 和 `flutter` 均有版本输出，`git pull` 无冲突。
- 依赖安装：`flutter pub get` 完成且无 error。
- dry-run：`docs/release/testflight-dry-run-latest.md` 各项为 PASS。
- 构建：`flutter build ios --release` 成功结束。
- 上传：App Store Connect 中可见新 build 且可分发。
- 归档：输出 `evidence archived at: docs/release/evidence/<timestamp>`。

## 3）上传后必须回填

1. `docs/release/testflight-preupload-checklist-v1.md`
2. `docs/release/go-no-go-latest.md`
3. `docs/release/release-checklist.md`
4. `docs/release/testflight-release-notes-draft-v1.md`（回填 build 号与最终说明）

## 4）最终过线条件

- preupload 清单 P0 项全部勾选。
- go/no-go 决策状态与实际一致。
- App Store Connect 里的 build 可见且可分发。
- 证据归档目录已生成并可追溯。

# TestFlight Dry Run Report

- Run At: 2026-03-10 17:06:27 CST
- Host: ZHENDONGJIN-MC2

## 1) flutter pub get
== flutter pub get ==
Resolving dependencies...
Downloading packages...
  flutter_lints 4.0.0 (6.0.0 available)
  flutter_secure_storage 9.2.4 (10.0.0 available)
  flutter_secure_storage_linux 1.2.3 (3.0.0 available)
  flutter_secure_storage_macos 3.1.3 (4.0.0 available)
  flutter_secure_storage_platform_interface 1.1.2 (2.0.1 available)
  flutter_secure_storage_web 1.2.1 (2.1.0 available)
  flutter_secure_storage_windows 3.1.2 (4.1.0 available)
  js 0.6.7 (0.7.2 available)
  lints 4.0.0 (6.1.0 available)
  meta 1.17.0 (1.18.1 available)
  win32 5.15.0 (6.0.0 available)
Got dependencies!
11 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
- Result: PASS

## 2) flutter analyze
== flutter analyze ==
Analyzing mobile...                                             
No issues found! (ran in 1.4s)
- Result: PASS

## 3) flutter test
== flutter test ==
00:00 +0: loading /Users/aaronking/Documents/aiProject/couple-planet/@couple-planet/apps/mobile/test/widget_test.dart
00:00 +0: /Users/aaronking/Documents/aiProject/couple-planet/@couple-planet/apps/mobile/test/i18n_test.dart: i18n key sets are aligned between zh and en
00:00 +1: /Users/aaronking/Documents/aiProject/couple-planet/@couple-planet/apps/mobile/test/i18n_test.dart: relation status mapper handles known and unknown values
00:00 +2: /Users/aaronking/Documents/aiProject/couple-planet/@couple-planet/apps/mobile/test/i18n_test.dart: api error mapper prioritizes code then message then fallback
00:00 +3: /Users/aaronking/Documents/aiProject/couple-planet/@couple-planet/apps/mobile/test/widget_test.dart: App boots to login page
00:00 +4: All tests passed!
- Result: PASS

## 4) flutter build ios --release --no-codesign
== flutter build ios --release --no-codesign ==
Warning: Building for device with codesigning disabled. You will have to manually codesign before deploying to device.
Building com.example.couplePlanetMobile for device (ios-release)...
Running Xcode build...                                          
Xcode build done.                                           28.9s
✓ Built build/ios/iphoneos/Runner.app (17.0MB)
- Result: PASS

## 5) Next Step
- Open Xcode Organizer and upload the generated archive with proper signing.

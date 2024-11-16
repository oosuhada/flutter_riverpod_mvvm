# Flutter Riverpod MVVM Architecture Lab

Riverpod `Notifier`와 MVVM 구조에서 **View → ViewModel → Repository**로 상태가 이동하는 과정을 UI에서 직접 확인할 수 있는 Flutter 포트폴리오 앱입니다.
`idle → loading → success / error` lifecycle과 immutable state version, request count, retry/reset interaction을 하나의 architecture dashboard로 시각화합니다.

## Preview

<p align="center">
  <img src=".github/assets/ui-preview.png" width="320" alt="Riverpod MVVM success state" />
</p>

<table>
  <tr>
    <td align="center"><strong>Idle</strong></td>
    <td align="center"><strong>Loading</strong></td>
  </tr>
  <tr>
    <td align="center"><img src=".github/assets/portfolio/01-idle.png" width="280" alt="Idle state" /></td>
    <td align="center"><img src=".github/assets/portfolio/02-loading.png" width="280" alt="Loading state" /></td>
  </tr>
  <tr>
    <td align="center"><strong>Success</strong></td>
    <td align="center"><strong>Error / Retry</strong></td>
  </tr>
  <tr>
    <td align="center"><img src=".github/assets/portfolio/03-success.png" width="280" alt="Success state" /></td>
    <td align="center"><img src=".github/assets/portfolio/04-error-retry.png" width="280" alt="Error and retry state" /></td>
  </tr>
</table>

모든 이미지는 Android Emulator에서 실제 interaction을 수행한 상태를 캡처한 화면입니다.

## What it does

- `Fetch`, `Refresh`, `Simulate error`, `Reset`으로 request lifecycle을 직접 전환합니다.
- sample JSON을 `User` 모델로 변환하고 Repository 결과를 `HomeState`에 반영합니다.
- `request count`, `state version`, `last updated`, data source를 UI에 노출합니다.
- success에서는 sample profile을 표시하고, error에서는 ViewModel이 잡은 repository exception과 retry 가능 상태를 보여줍니다.

## Architecture

```text
View (ConsumerWidget)
        │ watch / user event
        ▼
ViewModel (Notifier<HomeState>)
        │ async request
        ▼
Repository
        │ User / error
        └──────────────► immutable HomeState ──► View rebuild
```

- **View**: `ConsumerWidget`가 `homeViewModelProvider`를 구독합니다.
- **ViewModel**: `Notifier<HomeState>`가 loading/success/error 전환과 request orchestration을 담당합니다.
- **Repository**: 비동기 sample JSON 응답과 의도적인 503 sample error를 제공합니다.

## Tech Stack

- Flutter / Dart
- Riverpod (`flutter_riverpod` 2.6.1)
- Material 3
- Flutter widget tests

## Run

```bash
flutter pub get
flutter run
```

외부 API key나 별도 credential 없이 sample repository로 실행됩니다.

## Validation

이번 포트폴리오 화면 정리 과정에서 다음을 실제 확인했습니다.

- `flutter analyze` — **No issues found**
- `flutter test` — **3/3 tests passed**
- Android Emulator — Android 15 / API 35에서 idle, loading, success, error interaction 확인
- Android debug build — `build/app/outputs/flutter-apk/app-debug.apk` 생성 성공
- Emulator runtime — RenderFlex overflow 및 Flutter runtime exception 없음

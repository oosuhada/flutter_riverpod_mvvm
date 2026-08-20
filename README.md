# Flutter Riverpod MVVM Architecture Lab

Riverpod `Notifier`를 사용해 **View → ViewModel → Repository** 흐름과 request lifecycle을 화면 자체에서 관찰할 수 있게 만든 Flutter 학습 포트폴리오 앱입니다.

단순히 데이터를 한 번 불러오는 예제에서 확장해 `idle → loading → success / error` 상태, immutable state version, request count, source metadata, retry/reset interaction을 한 화면에서 비교할 수 있습니다.

## UI Preview

![Riverpod MVVM success state](.github/assets/ui-preview.png)

대표 화면은 Android Emulator에서 실제 `Fetch user` interaction을 수행한 뒤 캡처한 success state입니다.

### Interaction states

| Idle | Loading |
| --- | --- |
| ![Idle state](.github/assets/portfolio/01-idle.png) | ![Loading state](.github/assets/portfolio/02-loading.png) |

| Success | Error / Retry |
| --- | --- |
| ![Success state](.github/assets/portfolio/03-success.png) | ![Error state](.github/assets/portfolio/04-error-retry.png) |

## What the app demonstrates

- **View** — `ConsumerWidget`가 `homeViewModelProvider`를 구독하고 state 변화에 따라 다시 그려집니다.
- **ViewModel** — `Notifier<HomeState>`가 request orchestration과 immutable state transition을 담당합니다.
- **Repository** — mock REST/JSON 응답과 의도적인 503 sample error를 비동기로 제공합니다.
- **Lifecycle** — `idle`, `loading`, `success`, `error`를 명시적인 enum state로 표현합니다.
- **Traceability** — request count, state version, last updated time, source를 UI에 노출합니다.
- **Interaction** — Fetch, Refresh, Simulate error, Reset to idle을 직접 실행할 수 있습니다.

## Structure

```text
lib/
├── home_page.dart        # View / interactive architecture dashboard
├── home_view_model.dart  # Riverpod Notifier + immutable HomeState
├── user_repository.dart  # async sample data source + error simulation
├── user.dart             # immutable user model
└── main.dart             # ProviderScope + Material 3 app entrypoint
```

## Run & verify

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter run
```

The portfolio screenshots in `.github/assets/portfolio/` were captured from the Android Emulator after performing the corresponding interactions.

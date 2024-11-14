# Flutter Riverpod MVVM Practice

Riverpod의 `Notifier`/`ProviderScope`를 사용해 **View → ViewModel → Repository** 흐름을 연습한 작은 Flutter MVVM 학습 프로젝트입니다.

A compact Flutter learning project for practicing a **View → ViewModel → Repository** flow with Riverpod-managed state.

## UI Preview / 구현 화면

![Riverpod MVVM sample interface](.github/assets/ui-preview.png)

위 화면은 `lib/home_page.dart`에 구현된 실제 학습 UI를 Flutter Web으로 빌드해 캡처했습니다. 현재 기본 `lib/main.dart`는 빈 `MaterialApp` scaffold이므로, README preview는 의도된 Riverpod 예제 entrypoint인 `home_page.dart`를 대상으로 합니다.

The repository's default `lib/main.dart` is still a minimal blank scaffold. The screenshot intentionally renders `lib/home_page.dart`, which contains the actual Riverpod/MVVM exercise.

## What I Practiced / 학습 내용

- `ProviderScope`를 통한 Riverpod 상태 관리 진입점 구성
- `NotifierProvider` 기반 ViewModel 상태 갱신
- `Consumer`/`WidgetRef`를 이용한 UI 상태 구독
- Repository에서 사용자 데이터를 가져와 ViewModel 상태로 전달하는 흐름
- 상태 변경 시 화면이 다시 그려지는 reactive UI 구조

## Structure / 구조

```text
lib/
├── home_page.dart        # Consumer UI and demo entrypoint
├── home_view_model.dart  # Riverpod ViewModel / state
├── user_repository.dart  # data-access practice layer
├── user.dart             # model
└── main.dart             # minimal Flutter scaffold
```

## Run / 실행

```bash
flutter pub get
flutter run -t lib/home_page.dart
```

Web build used for the screenshot:

```bash
flutter build web --release -t lib/home_page.dart
```

## Status / 상태

이 저장소는 완성형 제품이 아니라 Riverpod과 MVVM 역할 분리를 익히기 위한 초기 학습 기록입니다. 2026-08-20 기준 의존성 설치와 Flutter Web release build를 다시 검증했습니다.

This is intentionally kept as an early learning artifact rather than presented as a production application. Dependencies and the Flutter Web release build were re-validated on 2026-08-20.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/user.dart';
import 'package:flutter_riverpod_mvvm/user_repository.dart';

enum RequestStatus { idle, loading, success, error }

extension RequestStatusLabel on RequestStatus {
  String get label => switch (this) {
        RequestStatus.idle => 'IDLE',
        RequestStatus.loading => 'LOADING',
        RequestStatus.success => 'SUCCESS',
        RequestStatus.error => 'ERROR',
      };
}

class HomeState {
  const HomeState({
    required this.status,
    required this.user,
    required this.lastUpdated,
    required this.requestCount,
    required this.stateVersion,
    required this.source,
    required this.errorMessage,
  });

  const HomeState.initial()
      : status = RequestStatus.idle,
        user = null,
        lastUpdated = null,
        requestCount = 0,
        stateVersion = 0,
        source = UserRepository.sourceLabel,
        errorMessage = null;

  final RequestStatus status;
  final User? user;
  final DateTime? lastUpdated;
  final int requestCount;
  final int stateVersion;
  final String source;
  final String? errorMessage;

  bool get isLoading => status == RequestStatus.loading;
  bool get hasUser => user != null;
}

class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() => const HomeState.initial();

  Future<void> fetchUser({bool simulateError = false}) async {
    if (state.isLoading) return;

    final requestCount = state.requestCount + 1;
    state = HomeState(
      status: RequestStatus.loading,
      user: state.user,
      lastUpdated: state.lastUpdated,
      requestCount: requestCount,
      stateVersion: state.stateVersion + 1,
      source: state.source,
      errorMessage: null,
    );

    try {
      final user = await ref
          .read(userRepositoryProvider)
          .getUser(shouldFail: simulateError);

      state = HomeState(
        status: RequestStatus.success,
        user: user,
        lastUpdated: DateTime.now(),
        requestCount: requestCount,
        stateVersion: state.stateVersion + 1,
        source: UserRepository.sourceLabel,
        errorMessage: null,
      );
    } on UserRepositoryException catch (error) {
      state = HomeState(
        status: RequestStatus.error,
        user: state.user,
        lastUpdated: state.lastUpdated,
        requestCount: requestCount,
        stateVersion: state.stateVersion + 1,
        source: state.source,
        errorMessage: error.message,
      );
    }
  }

  Future<void> refresh() => fetchUser();

  Future<void> simulateError() => fetchUser(simulateError: true);

  void reset() {
    state = const HomeState.initial();
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);

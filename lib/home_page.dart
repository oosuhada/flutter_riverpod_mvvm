import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Text('Riverpod MVVM Lab'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: _StatusBadge(status: state.status)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroCard(state: state),
              const SizedBox(height: 14),
              const _ArchitectureFlowCard(),
              const SizedBox(height: 14),
              _ProfileCard(state: state),
              const SizedBox(height: 14),
              _LifecycleCard(state: state),
              const SizedBox(height: 14),
              _RequestConsole(state: state),
              const SizedBox(height: 14),
              _ActionPanel(
                state: state,
                onFetch: viewModel.fetchUser,
                onRefresh: viewModel.refresh,
                onError: viewModel.simulateError,
                onReset: viewModel.reset,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primaryContainer,
            colors.tertiaryContainer,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.account_tree_outlined, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INTERACTIVE ARCHITECTURE DEMO',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w800,
                        color: colors.onPrimaryContainer,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  'State travels. UI explains.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Riverpod Notifier가 request lifecycle과 immutable state 변화를 화면에 그대로 드러냅니다.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _MiniBadge(
                      icon: Icons.tag_rounded,
                      label: 'request ${state.requestCount}',
                    ),
                    _MiniBadge(
                      icon: Icons.layers_outlined,
                      label: 'state v${state.stateVersion}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchitectureFlowCard extends StatelessWidget {
  const _ArchitectureFlowCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View → ViewModel → Repository',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'UI event → state orchestration → data source',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 13),
            const Row(
              children: [
                Expanded(
                  child: _FlowStep(
                    icon: Icons.phone_android_outlined,
                    title: 'View',
                    detail: 'watch',
                  ),
                ),
                _FlowArrow(),
                Expanded(
                  child: _FlowStep(
                    icon: Icons.tune_outlined,
                    title: 'ViewModel',
                    detail: 'notify',
                  ),
                ),
                _FlowArrow(),
                Expanded(
                  child: _FlowStep(
                    icon: Icons.storage_outlined,
                    title: 'Repository',
                    detail: 'fetch',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _FlowArrow extends StatelessWidget {
  const _FlowArrow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 15,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = state.user;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? _EmptyProfile(state: state)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: colors.primaryContainer,
                        child: Text(
                          user.name.characters.first,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: colors.onPrimaryContainer,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    user.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _AgeChip(age: user.age),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.headline,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.school_outlined,
                            size: 18, color: colors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.learningTrack,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'SOURCE',
                          value: state.source,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Metric(
                          label: 'UPDATED',
                          value: _formatTime(state.lastUpdated),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: 'STATE VERSION',
                          value: 'v${state.stateVersion}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Metric(
                          label: 'UPDATE COUNT',
                          value: '${state.requestCount} request(s)',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _EmptyProfile extends StatelessWidget {
  const _EmptyProfile({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final isError = state.status == RequestStatus.error;
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isError
                ? colors.errorContainer
                : colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            isError ? Icons.cloud_off_outlined : Icons.person_search_outlined,
            color: isError ? colors.onErrorContainer : colors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isError ? 'Repository request failed' : 'No profile loaded yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                isError
                    ? state.errorMessage ?? 'Unknown repository error'
                    : 'Fetch를 누르면 sample JSON이 User 모델로 변환되고 새로운 HomeState가 생성됩니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isError ? colors.error : colors.onSurfaceVariant,
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LifecycleCard extends StatelessWidget {
  const _LifecycleCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Request lifecycle',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Text(
                  'immutable HomeState',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RequestStatus.values
                  .map(
                    (status) => _LifecycleStep(
                      status: status,
                      selected: state.status == status,
                    ),
                  )
                  .toList(),
            ),
            if (state.isLoading) ...[
              const SizedBox(height: 14),
              const LinearProgressIndicator(),
              const SizedBox(height: 7),
              Text(
                'Repository Future를 await 중 · View는 loading state를 구독 중',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RequestConsole extends StatelessWidget {
  const _RequestConsole({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final message = switch (state.status) {
      RequestStatus.idle => 'Waiting for a UI event',
      RequestStatus.loading => 'ViewModel → Repository · request in flight',
      RequestStatus.success =>
        'Repository → ViewModel → View · state committed',
      RequestStatus.error =>
        'Repository → ViewModel · error captured, retry available',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.terminal_rounded, size: 20, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATE TRACE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 3),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'v${state.stateVersion}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.primary,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({
    required this.state,
    required this.onFetch,
    required this.onRefresh,
    required this.onError,
    required this.onReset,
  });

  final HomeState state;
  final Future<void> Function() onFetch;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onError;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final disabled = state.isLoading;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Trigger state changes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '같은 View에서 성공·실패·재시도·초기화를 비교하세요.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              key: const ValueKey('fetch-button'),
              onPressed: disabled ? null : onFetch,
              icon: state.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_rounded),
              label: Text(state.hasUser ? 'Fetch again' : 'Fetch user'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('refresh-button'),
                    onPressed: disabled ? null : onRefresh,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refresh'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    key: const ValueKey('error-button'),
                    onPressed: disabled ? null : onError,
                    icon: const Icon(Icons.bug_report_outlined),
                    label: const Text('Simulate error'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              key: const ValueKey('reset-button'),
              onPressed: disabled ? null : onReset,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset to idle'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LifecycleStep extends StatelessWidget {
  const _LifecycleStep({
    required this.status,
    required this.selected,
  });

  final RequestStatus status;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final icon = switch (status) {
      RequestStatus.idle => Icons.pause_circle_outline_rounded,
      RequestStatus.loading => Icons.sync_rounded,
      RequestStatus.success => Icons.check_circle_outline_rounded,
      RequestStatus.error => Icons.error_outline_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color:
            selected ? colors.primaryContainer : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: selected ? colors.primary : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 15, color: selected ? colors.primary : colors.outline),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground) = switch (status) {
      RequestStatus.idle => (
          colors.surfaceContainerHighest,
          colors.onSurfaceVariant
        ),
      RequestStatus.loading => (
          colors.secondaryContainer,
          colors.onSecondaryContainer
        ),
      RequestStatus.success => (
          colors.primaryContainer,
          colors.onPrimaryContainer
        ),
      RequestStatus.error => (colors.errorContainer, colors.onErrorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _AgeChip extends StatelessWidget {
  const _AgeChip({required this.age});

  final int age;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'age $age',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 9,
                  letterSpacing: 0.45,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

String _formatTime(DateTime? time) {
  if (time == null) return '—';
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
}

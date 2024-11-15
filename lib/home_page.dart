import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/home_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final hasUser = state.user != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod MVVM Lab'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('Learning project'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.secondaryContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_tree_outlined,
                          size: 58,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Reactive state flow',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '버튼 한 번으로 Repository → ViewModel → View 상태 변화를 확인합니다.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _FlowRow(),
                  const SizedBox(height: 22),
                  Text(
                    'View → ViewModel → Repository',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Riverpod Notifier가 repository의 사용자 데이터를 받아 UI 상태를 갱신하는 학습 예제입니다.',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current state',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 18),
                          _StateRow(
                            label: '이름',
                            value: state.user?.name ?? '대기 중',
                          ),
                          const Divider(height: 28),
                          _StateRow(
                            label: '나이',
                            value: state.user?.age.toString() ?? '-',
                          ),
                          const Divider(height: 28),
                          _StateRow(
                            label: '최근 갱신',
                            value: state.fetchTime == null
                                ? '-'
                                : _formatTime(state.fetchTime!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            ref.read(homeViewModelProvider.notifier).getUser();
                          },
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(hasUser ? Icons.refresh : Icons.download),
                    label: Text(
                      state.isLoading
                          ? 'Repository 응답 기다리는 중'
                          : hasUser
                              ? '데이터 다시 가져오기'
                              : '사용자 데이터 가져오기',
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hasUser
                        ? 'Repository 응답이 새 HomeState로 교체되어 화면이 다시 그려졌습니다.'
                        : '버튼을 누르면 1초 뒤 sample repository 응답이 상태에 반영됩니다.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}:${two(time.second)}';
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow();

  @override
  Widget build(BuildContext context) {
    Widget step(IconData icon, String label) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22),
              const SizedBox(height: 6),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        step(Icons.widgets_outlined, 'View'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 18),
        ),
        step(Icons.tune_outlined, 'ViewModel'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 18),
        ),
        step(Icons.storage_outlined, 'Repository'),
      ],
    );
  }
}

class _StateRow extends StatelessWidget {
  const _StateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 82,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

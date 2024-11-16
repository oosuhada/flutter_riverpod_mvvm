import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/home_view_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _PageBackdrop()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TopBar(state: state),
                  const SizedBox(height: 22),
                  _Hero(state: state),
                  const SizedBox(height: 18),
                  _PipelineCard(
                    state: state,
                    pulse: _pulseController,
                  ),
                  const SizedBox(height: 14),
                  _OutputCard(state: state),
                  const SizedBox(height: 14),
                  _LifecycleStrip(state: state),
                  const SizedBox(height: 14),
                  _ActionDock(
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
        ],
      ),
    );
  }
}

class _PageBackdrop extends StatelessWidget {
  const _PageBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F9FF),
            Color(0xFFF4F5FB),
            Color(0xFFF8F8FC),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _BlurOrb(
              size: 260,
              color: const Color(0xFF7C6CF3).withValues(alpha: 0.13),
            ),
          ),
          Positioned(
            top: 330,
            left: -110,
            child: _BlurOrb(
              size: 230,
              color: const Color(0xFF4BB9C8).withValues(alpha: 0.09),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF171A2B),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x25171A2B),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'R',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riverpod MVVM Lab',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
              ),
              const SizedBox(height: 1),
              Text(
                'Interactive architecture portfolio',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF7C8092),
                    ),
              ),
            ],
          ),
        ),
        _StatusBadge(status: state.status),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(21, 23, 21, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2B),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26171A2B),
            blurRadius: 32,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -56,
            right: -44,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x667C6CF3), Color(0x007C6CF3)],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _HeroPill(
                    icon: Icons.hub_outlined,
                    label: 'RIVERPOD + MVVM',
                  ),
                  const Spacer(),
                  Text(
                    'v${state.stateVersion.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Color(0xFF9296AA),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Make state\nvisible.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  height: 0.98,
                  letterSpacing: -1.8,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'View events travel through a Notifier and Repository.\nEvery transition is reflected back into the interface.',
                style: TextStyle(
                  color: Color(0xFFB7BAC8),
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 21),
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      label: 'REQUESTS',
                      value: '${state.requestCount}',
                      caption: 'repository calls',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 42,
                    color: const Color(0xFF303446),
                  ),
                  Expanded(
                    child: _HeroMetric(
                      label: 'STATE',
                      value: state.status.label,
                      caption: 'current lifecycle',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF9A8EFF), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD4D5DE),
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF777B91),
              fontSize: 9,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          Text(
            caption,
            style: const TextStyle(
              color: Color(0xFF777B91),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineCard extends StatelessWidget {
  const _PipelineCard({required this.state, required this.pulse});

  final HomeState state;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live state pipeline',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'View → ViewModel → Repository',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF777C90),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Color(0xFF6B5CE7),
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: constraints.maxWidth * 0.16,
                      right: constraints.maxWidth * 0.16,
                      top: 31,
                      child: _PipelineTrack(
                        status: state.status,
                        pulse: pulse,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _PipelineNode(
                            icon: Icons.phone_iphone_rounded,
                            title: 'View',
                            subtitle: 'watch',
                            active: state.status != RequestStatus.idle,
                          ),
                        ),
                        Expanded(
                          child: _PipelineNode(
                            icon: Icons.tune_rounded,
                            title: 'ViewModel',
                            subtitle: 'notify',
                            active: state.status != RequestStatus.idle,
                          ),
                        ),
                        Expanded(
                          child: _PipelineNode(
                            icon: Icons.cloud_outlined,
                            title: 'Repository',
                            subtitle: 'fetch',
                            active: state.status == RequestStatus.loading ||
                                state.status == RequestStatus.success ||
                                state.status == RequestStatus.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: _TraceLine(
              key: ValueKey(state.status),
              state: state,
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineTrack extends StatelessWidget {
  const _PipelineTrack({required this.status, required this.pulse});

  final RequestStatus status;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final active = status != RequestStatus.idle;
    return SizedBox(
      height: 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFE8E9F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            left: 0,
            top: 0,
            bottom: 0,
            width: active ? 180 : 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7367EE), Color(0xFF45B8C8)],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          if (status == RequestStatus.loading)
            AnimatedBuilder(
              animation: pulse,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(-1 + pulse.value * 2, 0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x887C6CF3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PipelineNode extends StatelessWidget {
  const _PipelineNode({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF171A2B) : const Color(0xFFF0F1F6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? const Color(0xFF292D42) : const Color(0xFFE5E6ED),
            ),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x1F171A2B),
                      blurRadius: 16,
                      offset: Offset(0, 7),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: active ? const Color(0xFFA89DFF) : const Color(0xFF9A9EAD),
            size: 24,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: const Color(0xFF303345),
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF999CAB),
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

class _TraceLine extends StatelessWidget {
  const _TraceLine({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final (icon, message, color, background) = switch (state.status) {
      RequestStatus.idle => (
          Icons.radio_button_checked_rounded,
          'Waiting for a UI event',
          const Color(0xFF717687),
          const Color(0xFFF5F5F8),
        ),
      RequestStatus.loading => (
          Icons.sync_rounded,
          'ViewModel → Repository · request in flight',
          const Color(0xFF6559D9),
          const Color(0xFFF1EFFF),
        ),
      RequestStatus.success => (
          Icons.check_circle_rounded,
          'Repository → ViewModel → View · state committed',
          const Color(0xFF17816D),
          const Color(0xFFE8F7F2),
        ),
      RequestStatus.error => (
          Icons.error_rounded,
          'Repository → ViewModel · error captured, retry available',
          const Color(0xFFB44E62),
          const Color(0xFFFFEFF2),
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Text(
            'state v${state.stateVersion}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _OutputCard extends StatelessWidget {
  const _OutputCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Output snapshot',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.35,
                    ),
              ),
              const Spacer(),
              Text(
                'immutable HomeState',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF999CAA),
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _OutputBody(
              key: ValueKey('${state.status}-${state.stateVersion}'),
              state: state,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutputBody extends StatelessWidget {
  const _OutputBody({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final user = state.user;

    if (state.status == RequestStatus.error) {
      return _ErrorOutput(state: state);
    }

    if (user == null) {
      return _EmptyOutput(state: state);
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7869EE), Color(0xFF4AB3C3)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x337C6CF3),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                user.name.characters.first,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 13),
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
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.6,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EEFF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'age ${user.age}',
                          style: const TextStyle(
                            color: Color(0xFF6659D8),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.headline,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF777C8D),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7FA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEFF4)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome_outlined,
                size: 17,
                color: Color(0xFF7668EA),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user.learningTrack,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4D5060),
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: _DataPoint(label: 'SOURCE', value: state.source),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DataPoint(
                label: 'UPDATED',
                value: _formatTime(state.lastUpdated),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DataPoint(
                label: 'VERSION',
                value: 'v${state.stateVersion}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyOutput extends StatelessWidget {
  const _EmptyOutput({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final loading = state.status == RequestStatus.loading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FA),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFEEEFF4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: loading ? const Color(0xFFF0EEFF) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE6E7ED)),
            ),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(13),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.3,
                      color: Color(0xFF7365E7),
                    ),
                  )
                : const Icon(
                    Icons.person_search_outlined,
                    color: Color(0xFF7D8190),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loading ? 'Fetching sample profile' : 'No profile loaded yet',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  loading
                      ? 'Repository Future를 await 중 · View는 loading state를 구독 중'
                      : 'Fetch를 누르면 JSON → User → HomeState 흐름이 이 영역에 시각화됩니다.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF7C8090),
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorOutput extends StatelessWidget {
  const _ErrorOutput({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3F5), Color(0xFFFFF8F8)],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFF8D8DE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE1E7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFFB24C60),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Repository request failed',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF8E394B),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.errorMessage ?? 'Unknown repository error',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB24C60),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'The ViewModel captured the exception. Retry is safe.',
                  style: TextStyle(
                    color: Color(0xFF8A7780),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataPoint extends StatelessWidget {
  const _DataPoint({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FA),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9A9DAC),
              fontSize: 8,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF4C4F5F),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LifecycleStrip extends StatelessWidget {
  const _LifecycleStrip({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          const Icon(
            Icons.route_outlined,
            size: 18,
            color: Color(0xFF6F62E2),
          ),
          const SizedBox(width: 9),
          Text(
            'Lifecycle',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: RequestStatus.values.map((status) {
                final selected = state.status == status;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          height: 6,
                          decoration: BoxDecoration(
                            color: selected
                                ? _statusColor(status)
                                : const Color(0xFFE9EAF0),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      if (status != RequestStatus.error)
                        const SizedBox(width: 4),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            state.status.label,
            style: TextStyle(
              color: _statusColor(state.status),
              fontSize: 10,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionDock extends StatelessWidget {
  const _ActionDock({
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

    return _Surface(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'State controls',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Trigger the same architecture from one View.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF8C8F9E),
                          ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                key: const ValueKey('reset-button'),
                tooltip: 'Reset to idle',
                onPressed: disabled ? null : onReset,
                icon: const Icon(Icons.restart_alt_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            key: const ValueKey('fetch-button'),
            onPressed: disabled ? null : onFetch,
            icon: state.isLoading
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.arrow_downward_rounded),
            label: Text(state.hasUser ? 'Fetch again' : 'Fetch user'),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('refresh-button'),
                  onPressed: disabled ? null : onRefresh,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Refresh'),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('error-button'),
                  onPressed: disabled ? null : onError,
                  icon: const Icon(Icons.bug_report_outlined, size: 18),
                  label: const Text('Simulate error'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9EAF0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C171A2B),
            blurRadius: 22,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      key: const ValueKey('status-badge'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(RequestStatus status) => switch (status) {
      RequestStatus.idle => const Color(0xFF7D8190),
      RequestStatus.loading => const Color(0xFF6D5FE5),
      RequestStatus.success => const Color(0xFF16816C),
      RequestStatus.error => const Color(0xFFB44E62),
    };

String _formatTime(DateTime? time) {
  if (time == null) return '—';
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  final second = time.second.toString().padLeft(2, '0');
  return '$hour:$minute:$second';
}

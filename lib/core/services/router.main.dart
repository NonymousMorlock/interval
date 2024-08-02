part of 'router.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (_, __, child) {
        return AppStateReactor(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => BlocProvider(
            create: (_) => sl<HomeViewModelCubit>(),
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: CreateOrUpdateIntervalSessionPage.path,
          builder: (_, state) => BlocProvider(
            create: (_) => sl<ManageIntervalCubit>(),
            child: CreateOrUpdateIntervalSessionPage(
              session: state.extra as IntervalSession?,
            ),
          ),
        ),
      ],
    ),
  ],
);

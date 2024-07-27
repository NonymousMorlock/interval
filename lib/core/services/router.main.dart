part of 'router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<HomeViewModelCubit>(),
        child: const HomePage(),
      ),
    ),
  ],
);

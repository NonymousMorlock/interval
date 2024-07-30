part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initMemory();
  await _initHome();
  await _initManageInterval();
}

Future<void> _initManageInterval() async {
  sl
    ..registerFactory(() => ManageIntervalCubit(sl()))
    ..registerLazySingleton(() => ManageIntervalLocalRepository(sl()));
}

Future<void> _initHome() async {
  sl
    ..registerFactory(() => HomeViewModelCubit(sl()))
    ..registerLazySingleton(() => HomeLocalRepository(sl()));
}

Future<void> _initMemory() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  if (CurrentPlatform.instance.isDesktop) {
    final database = await DatabaseHelper.initDatabaseDesktop();
    sl.registerLazySingleton(() => database);
  } else {
    final database = await DatabaseHelper.initDatabaseMobile();
    sl.registerLazySingleton(() => database);
  }
}

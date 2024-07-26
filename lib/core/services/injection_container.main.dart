part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => prefs);
}

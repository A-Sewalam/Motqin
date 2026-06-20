import 'package:get_it/get_it.dart';
import 'package:motqin/core/network/api_client.dart';
import 'package:motqin/features/auth/services/auth_service.dart';
import 'package:motqin/features/auth/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Core ───────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ── Services ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthService>(() => AuthService(sl<ApiClient>()));

  // ── Blocs (registered as factories so each BlocProvider gets a fresh instance)
  sl.registerFactory<AuthBloc>(() => AuthBloc(authService: sl<AuthService>()));

  // ── Add more as you build each feature ────────────────────────────────────
  // sl.registerLazySingleton<SubjectService>(() => SubjectService(sl<ApiClient>()));
  // sl.registerFactory<SubjectBloc>(() => SubjectBloc(service: sl<SubjectService>()));
}

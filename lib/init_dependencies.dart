import 'package:ajudafio_mobile/features/auth/data/datasources/auth_remote_data_resource.dart';
import 'package:ajudafio_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_sign_up.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: '.env');

  _initAuth();
}

void _initAuth() {
  serviceLocator
    ..registerLazySingleton<http.Client>(http.Client.new)
    ..registerFactory<AuthRemoteDataResource>(
      () => AuthRemoteDataResourceImpl(client: serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerLazySingleton(() => AuthBloc(userSignUp: serviceLocator()));
}

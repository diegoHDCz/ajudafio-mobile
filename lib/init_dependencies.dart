import 'package:ajudafio_mobile/core/network/authenticated_http_client.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_remote_data_resource.dart';
import 'package:ajudafio_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/logout_user.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/restore_session.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_login.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_sign_up.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerFactory<AuthRemoteDataResource>(
      () => AuthRemoteDataResourceImpl(client: serviceLocator()),
    )
    ..registerFactory<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(serviceLocator()),
    )
    ..registerLazySingleton<AuthenticatedHttpClient>(
      () => AuthenticatedHttpClient(
        inner: serviceLocator(),
        localDataSource: serviceLocator(),
        remoteDataResource: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => RestoreSession(serviceLocator()))
    ..registerFactory(() => LogoutUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        restoreSession: serviceLocator(),
        logoutUser: serviceLocator(),
      ),
    );
}

import 'package:ajudafio_mobile/core/error/exceptions.dart';
import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_remote_data_resource.dart';
import 'package:ajudafio_mobile/features/auth/data/models/auth_token_model.dart';
import 'package:ajudafio_mobile/features/auth/data/models/user_model.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:ajudafio_mobile/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.remoteDataResource, this.localDataSource);

  final AuthRemoteDataResource remoteDataResource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final tokens = await remoteDataResource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      return right(await _persistAndDecode(tokens));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await remoteDataResource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(await _persistAndDecode(tokens));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> restoreSession() async {
    try {
      final storedTokens = await localDataSource.getTokens();
      if (storedTokens == null) {
        return left(Failure('Nenhuma sessão salva.'));
      }

      if (!storedTokens.isExpired) {
        return right(UserModel.fromToken(storedTokens.accessToken));
      }

      final refreshedTokens = await remoteDataResource.refresh(
        storedTokens.refreshToken,
      );
      return right(await _persistAndDecode(refreshedTokens));
    } catch (e) {
      await localDataSource.clearTokens();
      return left(Failure(e is ServerException ? e.message : e.toString()));
    }
  }

  @override
  Future<void> logout() {
    return localDataSource.clearTokens();
  }

  Future<User> _persistAndDecode(AuthTokenModel tokens) async {
    await localDataSource.saveTokens(tokens);
    return UserModel.fromToken(tokens.accessToken);
  }
}

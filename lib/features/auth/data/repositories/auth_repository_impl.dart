import 'package:ajudafio_mobile/core/error/exceptions.dart';
import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_remote_data_resource.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.remoteDataResource);

  final AuthRemoteDataResource remoteDataResource;

  @override
  Future<Either<Failure, void>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      await remoteDataResource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final token = await remoteDataResource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(token);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

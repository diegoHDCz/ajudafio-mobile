import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, void>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

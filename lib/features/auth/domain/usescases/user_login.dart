import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/core/usecase/usecase.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<String, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, String>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({required this.email, required this.password});
}

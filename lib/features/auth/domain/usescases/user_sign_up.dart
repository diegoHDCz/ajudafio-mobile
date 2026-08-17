import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/core/usecase/usecase.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:ajudafio_mobile/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
    );
  }

}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  final String phone;
  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}
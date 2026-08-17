import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/core/usecase/usecase.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:ajudafio_mobile/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class RestoreSession implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  RestoreSession(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.restoreSession();
  }
}

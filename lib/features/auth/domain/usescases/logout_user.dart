import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/core/usecase/usecase.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUser(this.authRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    await authRepository.logout();
    return right(null);
  }
}

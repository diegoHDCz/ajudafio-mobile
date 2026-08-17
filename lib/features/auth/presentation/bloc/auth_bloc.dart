import 'package:ajudafio_mobile/core/error/failures.dart';
import 'package:ajudafio_mobile/features/auth/data/models/user_model.dart';
import 'package:ajudafio_mobile/features/auth/domain/entities/user.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_login.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;

  AuthBloc({required UserSignUp userSignUp, required UserLogin userLogin})
    : _userSignUp = userSignUp,
      _userLogin = userLogin,
      super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthLogout>((event, emit) => emit(AuthInitial()));
  }

  Future<void> _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
      ),
    );
    _emitTokenResult(res, emit);
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    _emitTokenResult(res, emit);
  }

  void _emitTokenResult(
    Either<Failure, String> res,
    Emitter<AuthState> emit,
  ) {
    res.fold((failure) => emit(AuthFailure(failure.message)), (token) {
      try {
        emit(AuthSuccess(UserModel.fromToken(token)));
      } catch (_) {
        emit(const AuthFailure('Não foi possível validar o token recebido.'));
      }
    });
  }
}

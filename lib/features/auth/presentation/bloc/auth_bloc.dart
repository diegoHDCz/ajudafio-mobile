import 'package:ajudafio_mobile/features/auth/domain/entities/user.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/logout_user.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/restore_session.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_login.dart';
import 'package:ajudafio_mobile/features/auth/domain/usescases/user_sign_up.dart';
import 'package:ajudafio_mobile/core/usecase/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final RestoreSession _restoreSession;
  final LogoutUser _logoutUser;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required RestoreSession restoreSession,
    required LogoutUser logoutUser,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _restoreSession = restoreSession,
       _logoutUser = logoutUser,
       super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthCheckSession>(_onAuthCheckSession);
    on<AuthLogout>(_onAuthLogout);
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
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onAuthCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final res = await _restoreSession(const NoParams());
    res.fold(
      (_) => emit(AuthUnauthenticated()),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    await _logoutUser(const NoParams());
    emit(AuthUnauthenticated());
  }
}

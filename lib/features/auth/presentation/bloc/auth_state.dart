part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

/// Reached either after a boot-time session restore found no valid
/// session, or after an explicit logout — distinct from [AuthInitial]
/// (the bloc's pre-check starting state) so the UI can tell "haven't
/// checked yet" apart from "checked, definitely logged out".
final class AuthUnauthenticated extends AuthState {}

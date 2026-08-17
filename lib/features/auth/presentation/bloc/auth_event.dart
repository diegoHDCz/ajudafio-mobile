part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
}

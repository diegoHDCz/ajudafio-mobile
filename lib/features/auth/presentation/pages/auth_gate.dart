import 'package:ajudafio_mobile/core/common/pages/main_shell_page.dart';
import 'package:ajudafio_mobile/core/common/widgets/loader.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shown while [AuthBloc] resolves the `AuthCheckSession` dispatched right
/// after it's created, then redirects to [MainShellPage] or [LoginPage]
/// once a terminal state ([AuthSuccess] / [AuthUnauthenticated]) is reached.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(context, MainShellPage.route());
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(context, LoginPage.route());
        }
      },
      builder: (context, state) => const Scaffold(body: Loader()),
    );
  }
}

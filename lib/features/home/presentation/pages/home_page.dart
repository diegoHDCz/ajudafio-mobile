import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:ajudafio_mobile/features/auth/domain/entities/user.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Only reachable once [AuthBloc] has emitted [AuthSuccess] — both the
/// sign in and sign up flows navigate here via [Navigator.pushAndRemoveUntil],
/// clearing the auth pages from the stack so the user can't navigate back
/// to them without logging out first.
class HomePage extends StatelessWidget {
  static Route route(User user) =>
      MaterialPageRoute(builder: (context) => HomePage(user: user));

  final User user;
  const HomePage({super.key, required this.user});

  void _onLogoutPressed(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogout());
    Navigator.pushAndRemoveUntil(context, LoginPage.route(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => _onLogoutPressed(context),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppPallet.secondaryColor,
                size: 64,
              ),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo, ${user.name}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPallet.textColor,
                ),
              ),
              if (user.email.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppPallet.textColorSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:ajudafio_mobile/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Only reachable once [AuthBloc] has emitted [AuthSuccess] — both the
/// sign in and sign up flows navigate here via [Navigator.pushAndRemoveUntil],
/// clearing the auth pages from the stack so the user can't navigate back
/// to them without logging out first. Reads the logged-in user from
/// [AppUserCubit] rather than a constructor argument, so any feature can
/// reach the same session state without threading it through routes.
class HomePage extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  void _onLogoutPressed(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogout());
    Navigator.pushAndRemoveUntil(context, LoginPage.route(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final appUserState = context.watch<AppUserCubit>().state;
    if (appUserState is! AppUserLoggedIn) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final user = appUserState.user;

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

import 'package:ajudafio_mobile/core/theme/theme.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/auth_gate.dart';
import 'package:ajudafio_mobile/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>()..add(AuthCheckSession()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ajudafio',
      theme: AppTheme.lightThemeMode,
      home: const AuthGate(),
    );
  }
}

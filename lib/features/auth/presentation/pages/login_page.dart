import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:ajudafio_mobile/features/auth/data/datasources/auth_remote_data_resource.dart';
import 'package:ajudafio_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ajudafio_mobile/features/auth/domain/auth_repository.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/signup_page.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_field.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepositoryImpl(
    AuthRemoteDataResourceImpl(),
  );
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> onLoginPressed() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final result = await authRepository.loginWithEmailPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;
    setState(() => isLoading = false);

    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (token) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 20,
                right: 20,
                bottom: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/ajudafio_logo2.png',
                        height: 120,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppPallet.textColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthField(
                        hintText: 'E-mail',
                        controller: emailController,
                      ),
                      const SizedBox(height: 15),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        isObscureText: true,
                      ),
                      const SizedBox(height: 30),
                      AuthGradientButton(
                        buttonText: 'Sign In',
                        isLoading: isLoading,
                        onPressed: onLoginPressed,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, SignUpPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: AppPallet.textColorSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppPallet.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

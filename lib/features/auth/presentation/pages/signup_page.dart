import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_field.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppPallet.textColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthField(
                        hintText: 'Name',
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
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
                      const AuthGradientButton(buttonText: 'Sign Up'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, LoginPage.route());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppPallet.textColorSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
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

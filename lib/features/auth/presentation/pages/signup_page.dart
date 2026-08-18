import 'package:ajudafio_mobile/core/common/widgets/loader.dart';
import 'package:ajudafio_mobile/core/theme/app_pallet.dart';
import 'package:ajudafio_mobile/core/utils/phone_input_formatter.dart';
import 'package:ajudafio_mobile/core/utils/show_snackbar.dart';
import 'package:ajudafio_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ajudafio_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_field.dart';
import 'package:ajudafio_mobile/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:ajudafio_mobile/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void onSignUpPressed() {
    if (!formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthSignUp(
        name: nameController.text.trim(),
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                HomePage.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                LayoutBuilder(
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
                                hintText: 'Phone',
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [PhoneInputFormatter()],
                                validator: phoneValidator,
                              ),
                              const SizedBox(height: 15),
                              AuthField(
                                hintText: 'Password',
                                controller: passwordController,
                                isObscureText: true,
                              ),
                              const SizedBox(height: 30),
                              AuthGradientButton(
                                buttonText: 'Sign Up',
                                isLoading: isLoading,
                                onPressed: onSignUpPressed,
                              ),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
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
                if (isLoading) const Positioned.fill(child: Loader()),
              ],
            );
          },
        ),
      ),
    );
  }
}

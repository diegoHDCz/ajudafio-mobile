import 'package:ajudafio_mobile/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:ajudafio_mobile/features/professional_list/presentation/widgets/filter_button.dart';
import 'package:ajudafio_mobile/features/professional_list/presentation/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfesstionalListPage extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const ProfesstionalListPage());

  const ProfesstionalListPage({super.key});

  @override
  State<ProfesstionalListPage> createState() => _ProfesstionalListPageState();
}

class _ProfesstionalListPageState extends State<ProfesstionalListPage> {
  @override
  Widget build(BuildContext context) {
    final appUserState = context.watch<AppUserCubit>().state;
    if (appUserState is! AppUserLoggedIn) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final user = appUserState.user;
    final firstName = user.name.split(' ').first;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Olá, $firstName, \n',
                        children: const [
                          TextSpan(
                            text: 'Quem você precisa cuidar hoje?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.black45),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: SearchField()),
                  const SizedBox(width: 12),
                  const FilterButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

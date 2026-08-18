import 'package:ajudafio_mobile/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

/// Holds the currently logged in user (or the lack of one) so any feature
/// can read the session without depending on the auth feature directly.
/// [AuthBloc] is the only thing that calls [updateUser] — it does so
/// whenever a login/sign-up/session-restore succeeds or a logout happens.
class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    emit(user == null ? AppUserInitial() : AppUserLoggedIn(user));
  }
}

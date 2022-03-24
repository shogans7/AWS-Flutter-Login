import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_login/data_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_credentials.dart';
import 'package:aws_login/auth/auth_repository.dart';
import 'package:aws_login/home_state.dart';

import 'models/User.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository authRepo;
  final DataRepository dataRepo;

  HomeCubit({required this.authRepo, required this.dataRepo})
      : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepo.attemptAutoLogin();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      User? user = await dataRepo.getUserById(userId);
      // need to remove this, its a mess
      user ??= await dataRepo.createUser(
        userId: userId,
        username: 'User-${UUID().toString()}',
      );

      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredentials credentials) async {
    try {
      User? user;
      if (credentials.userId != null) {
        user = await dataRepo.getUserById(credentials.userId.toString());
      }

      user ??= await dataRepo.createUser(
        // toString appropriate here? maybe emit unauth above?
        userId: credentials.userId.toString(),
        username: credentials.username,
        email: credentials.email,
      );

      emit(Authenticated(user: user));
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}

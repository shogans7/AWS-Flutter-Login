import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_credentials.dart';
import 'package:aws_login/home_cubit.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final HomeCubit homeCubit;

  AuthCubit({required this.homeCubit}) : super(AuthState.login);

  late AuthCredentials credentials;

  void showLogin() => emit(AuthState.login);
  void showSignUp() => emit(AuthState.signUp);
  void showConfirmSignUp({
    required String username,
    required String email,
    required String password,
  }) {
    credentials = AuthCredentials(
      username: username,
      email: email,
      password: password,
    );
    emit(AuthState.confirmSignUp);
  }

  void launchSession(AuthCredentials credentials) =>
      homeCubit.showSession(credentials);
}

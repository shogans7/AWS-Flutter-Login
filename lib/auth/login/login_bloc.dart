import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_credentials.dart';
import 'package:aws_login/auth/auth_cubit.dart';
import 'package:aws_login/auth/auth_repository.dart';
import 'package:aws_login/auth/form_submission_status.dart';
import 'package:aws_login/auth/login/login_event.dart';
import 'package:aws_login/auth/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginBloc({required this.authRepo, required this.authCubit})
      : super(LoginState()) {
    on<LoginUsernameChanged>(_mapLoginUsernameChanged);
    on<LoginPasswordChanged>(_mapLoginPasswordChanged);
    on<LoginSubmitted>(_mapLoginSubmitted);
  }

  _mapLoginUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(username: event.username));
  }

  _mapLoginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  _mapLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      final userId = await authRepo.login(
        username: state.username,
        password: state.password,
      );
      emit(state.copyWith(formStatus: SubmissionSuccess()));

      authCubit.launchSession(AuthCredentials(
        username: state.username,
        userId: userId,
      ));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

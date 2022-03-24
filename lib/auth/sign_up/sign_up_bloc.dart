import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_cubit.dart';
import 'package:aws_login/auth/auth_repository.dart';
import 'package:aws_login/auth/form_submission_status.dart';
import 'package:aws_login/auth/sign_up/sign_up_event.dart';
import 'package:aws_login/auth/sign_up/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  SignUpBloc({required this.authRepo, required this.authCubit})
      : super(SignUpState()) {
    on<SignUpUsernameChanged>(_mapSignUpUsernameChanged);
    on<SignUpEmailChanged>(_mapSignUpEmailChanged);
    on<SignUpPasswordChanged>(_mapSignUpPasswordChanged);
    on<SignUpSubmitted>(_mapSignUpSubmitted);
  }

  _mapSignUpUsernameChanged(
      SignUpUsernameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(username: event.username));
  }

  _mapSignUpEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  _mapSignUpPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  _mapSignUpSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await authRepo.signUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(formStatus: SubmissionSuccess()));

      authCubit.showConfirmSignUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

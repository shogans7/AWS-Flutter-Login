import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_cubit.dart';
import 'package:aws_login/auth/auth_repository.dart';
import 'package:aws_login/auth/form_submission_status.dart';
import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  ConfirmationBloc({
    required this.authRepo,
    required this.authCubit,
  }) : super(ConfirmationState()) {
    on<ConfirmationCodeChanged>(_mapConfirmationCodeChanged);
    on<ConfirmationSubmitted>(_mapConfirmationSubmitted);
  }

  _mapConfirmationCodeChanged(
      ConfirmationCodeChanged event, Emitter<ConfirmationState> emit) {
    emit(state.copyWith(code: event.code));
  }

  _mapConfirmationSubmitted(
      ConfirmationSubmitted event, Emitter<ConfirmationState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await authRepo.confirmSignUp(
        username: authCubit.credentials.username,
        confirmationCode: state.code,
      );
      emit(state.copyWith(formStatus: SubmissionSuccess()));

      final credentials = authCubit.credentials;
      // next two lines were not in OG
      final userId = await authRepo.login(
        username: credentials.username,
        password: credentials.password.toString(),
      );
      credentials.userId = userId;
      print(credentials.username);
      authCubit.launchSession(credentials);
    } catch (e) {
      print(e);
      emit(state.copyWith(formStatus: SubmissionFailed(Exception(e))));
    }
  }
}

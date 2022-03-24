import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_cubit.dart';
import 'package:aws_login/auth/auth_repository.dart';
import 'package:aws_login/auth/form_submission_status.dart';
import 'package:aws_login/auth/sign_up/sign_up_bloc.dart';
import 'package:aws_login/auth/sign_up/sign_up_event.dart';
import 'package:aws_login/auth/sign_up/sign_up_state.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _signUpForm(),
            _showLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                _usernameField(),
                const SizedBox(height: 15),
                _emailField(),
                const SizedBox(height: 15),
                _passwordField(),
                const SizedBox(height: 10),
                _signUpButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Username',
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          border: border(),
          focusedBorder: border(),
          disabledBorder: border(),
          enabledBorder: border(),
          errorBorder: border(),
        ),
        validator: (value) =>
            state.isValidUsername ? null : 'Username is too short',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: 'Email',
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          border: border(),
          focusedBorder: border(),
          disabledBorder: border(),
          enabledBorder: border(),
          errorBorder: border(),
        ),
        validator: (value) => state.isValidUsername ? null : 'Invalid email',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpEmailChanged(email: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: const Icon(Icons.security),
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          border: border(),
          focusedBorder: border(),
          disabledBorder: border(),
          enabledBorder: border(),
          errorBorder: border(),
        ),
        validator: (value) =>
            state.isValidPassword ? null : 'Pleaser enter a valid password.',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<SignUpBloc>().add(SignUpSubmitted());
                }
              },
              child: const Text('Sign Up'),
            );
    });
  }

  Widget _showLoginButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: const Text('Already have an account? Sign in.'),
        onPressed: () => context.read<AuthCubit>().showLogin(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  border() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Color(0xffB3ABAB),
        width: 1.0,
      ),
    );
  }
}

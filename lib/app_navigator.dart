import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/auth/auth_cubit.dart';
import 'package:aws_login/auth/auth_navigator.dart';
import 'package:aws_login/loading_view.dart';
import 'package:aws_login/home_cubit.dart';
import 'package:aws_login/home_state.dart';
import 'package:aws_login/home_view.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show loading screen
          if (state is UnknownSessionState) MaterialPage(child: LoadingView()),

          // Show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(homeCubit: context.read<HomeCubit>()),
                child: AuthNavigator(),
              ),
            ),

          // Show session flow
          if (state is Authenticated) MaterialPage(child: HomeView(username: state.user!.username,))
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}

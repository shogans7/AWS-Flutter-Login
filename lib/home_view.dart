import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aws_login/home_cubit.dart';

class HomeView extends StatelessWidget {
  final String username;

  const HomeView({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello $username'),
            const SizedBox(height: 20,),
            TextButton(
              child: const Text('Sign out'),
              onPressed: () => BlocProvider.of<HomeCubit>(context).signOut(),
            )
          ],
        ),
      ),
    );
  }
}

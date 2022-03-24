import 'models/User.dart';

abstract class HomeState {}

class UnknownSessionState extends HomeState {}

class Unauthenticated extends HomeState {}

class Authenticated extends HomeState {
  final User? user;

  Authenticated({required this.user});
}

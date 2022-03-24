import 'package:amplify_flutter/amplify_flutter.dart';

import 'models/User.dart';

class DataRepository {
  Future<User?> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      if (users.isNotEmpty) {
        return users.first;
      } else {
        print("had to return null user on get by ID query");
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> createUser({
    required String userId,
    required String username,
    String? email,
  }) async {
    final newUser = User(id: userId, username: username, email: email);
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }
}

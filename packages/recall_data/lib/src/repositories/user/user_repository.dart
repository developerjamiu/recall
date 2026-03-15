import 'package:common/common.dart';

abstract class UserRepository {
  Future<User> createUser(User user);

  Future<User?> getUserByEmail(String email);

  Future<User?> getUserById(String id);
}

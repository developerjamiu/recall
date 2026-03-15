import 'package:common/models/user.dart';
import 'package:jao/jao.dart';
import 'package:recall_data/recall_data.dart';

Future<void> initTestDatabase() async {
  Environment.init();

  await Jao.configure(
    adapter: databaseAdapter,
    config: databaseConfig,
  );
}

Future<User> createTestUser(
  JaoUserRepository userRepository, {
  String? email,
}) async {
  return userRepository.createUser(
    User.fromOAuthData(
      email: email ?? 'test-${DateTime.now().millisecondsSinceEpoch}@test.com',
      firstName: 'Test',
      lastName: 'User',
      provider: AuthProvider.google,
      providerId: 'test-provider-id',
    ),
  );
}

void cleanupTestDatabase() {
  Jao.reset();
}

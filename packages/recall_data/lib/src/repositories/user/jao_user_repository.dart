import 'package:common/models/user.dart' as models;
import 'package:recall_data/recall_data.dart';

class JaoUserRepository implements UserRepository {
  const JaoUserRepository();

  @override
  Future<models.User> createUser(models.User user) async {
    final appUser = await AppUsers.objects.create({
      'id': user.id,
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'provider': user.provider.name,
      'provider_id': user.providerId,
      'avatar_url': user.avatarUrl,
    });

    return _toModel(appUser);
  }

  @override
  Future<models.User?> getUserByEmail(String email) async {
    final result = await AppUsers.objects
        .filter(AppUsers.$.email.eq(email))
        .first();

    if (result == null) return null;
    return _toModel(result);
  }

  @override
  Future<models.User?> getUserById(String id) async {
    final result = await AppUsers.objects
        .filter(AppUsers.$.id.eq(id))
        .first();

    if (result == null) return null;
    return _toModel(result);
  }

  models.User _toModel(AppUser appUser) {
    return models.User(
      id: appUser.id,
      email: appUser.email,
      firstName: appUser.firstName,
      lastName: appUser.lastName,
      provider: models.AuthProvider.values.byName(appUser.provider),
      providerId: appUser.providerId,
      avatarUrl: appUser.avatarUrl,
      createdAt: appUser.createdAt,
      updatedAt: appUser.updatedAt,
    );
  }
}

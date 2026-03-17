import 'package:recall_data/recall_data.dart';

class JaoRefreshTokenRepository implements RefreshTokenRepository {
  const JaoRefreshTokenRepository();

  @override
  Future<void> storeRefreshToken({
    required String userId,
    required String tokenHash,
    required DateTime expiresAt,
  }) async {
    await RefreshTokenEntrys.objects.create({
      'user_id': userId,
      'token_hash': tokenHash,
      'expires_at': expiresAt,
    });
  }

  @override
  Future<String?> validateRefreshToken(String tokenHash) async {
    final now = DateTime.now().toUtc();

    final result = await RefreshTokenEntrys.objects
        .filter(
          RefreshTokenEntrys.$.tokenHash.eq(tokenHash) &
              RefreshTokenEntrys.$.revokedAt.isNull(),
        )
        .first();

    if (result == null) return null;
    if (result.expiresAt.isBefore(now)) return null;

    return result.userId;
  }

  @override
  Future<void> revokeRefreshToken(String tokenHash) async {
    await RefreshTokenEntrys.objects
        .filter(RefreshTokenEntrys.$.tokenHash.eq(tokenHash))
        .update({'revoked_at': DateTime.now().toUtc()});
  }

  @override
  Future<void> revokeAllUserTokens(String userId) async {
    await RefreshTokenEntrys.objects
        .filter(
          RefreshTokenEntrys.$.userId.eq(userId) &
              RefreshTokenEntrys.$.revokedAt.isNull(),
        )
        .update({'revoked_at': DateTime.now().toUtc()});
  }
}

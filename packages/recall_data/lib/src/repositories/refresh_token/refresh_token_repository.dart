abstract class RefreshTokenRepository {
  Future<void> storeRefreshToken({
    required String userId,
    required String tokenHash,
    required DateTime expiresAt,
  });

  Future<String?> validateRefreshToken(String tokenHash);

  Future<void> revokeRefreshToken(String tokenHash);

  Future<void> revokeAllUserTokens(String userId);
}

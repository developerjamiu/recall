@Tags(['integration'])
library;

import 'package:recall_data/recall_data.dart';
import 'package:test/test.dart';

import '../../test_helper.dart';

void main() {
  late JaoRefreshTokenRepository tokenRepository;
  late JaoUserRepository userRepository;
  late String testUserId;

  setUpAll(() async {
    await initTestDatabase();

    tokenRepository = const JaoRefreshTokenRepository();
    userRepository = const JaoUserRepository();

    final user = await createTestUser(userRepository);
    testUserId = user.id;
  });

  tearDownAll(() {
    cleanupTestDatabase();
  });

  group('JaoRefreshTokenRepository', () {
    group('storeRefreshToken', () {
      test('stores a token without error', () async {
        await expectLater(
          tokenRepository.storeRefreshToken(
            userId: testUserId,
            tokenHash: 'hash-store-${DateTime.now().millisecondsSinceEpoch}',
            expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
          ),
          completes,
        );
      });
    });

    group('validateRefreshToken', () {
      test('returns userId for a valid non-expired token', () async {
        final hash = 'hash-valid-${DateTime.now().millisecondsSinceEpoch}';
        await tokenRepository.storeRefreshToken(
          userId: testUserId,
          tokenHash: hash,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
        );

        final userId = await tokenRepository.validateRefreshToken(hash);

        expect(userId, equals(testUserId));
      });

      test('returns null for non-existent token', () async {
        final userId =
            await tokenRepository.validateRefreshToken('non-existent-hash');

        expect(userId, isNull);
      });

      test('returns null for expired token', () async {
        final hash = 'hash-expired-${DateTime.now().millisecondsSinceEpoch}';
        await tokenRepository.storeRefreshToken(
          userId: testUserId,
          tokenHash: hash,
          expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
        );

        final userId = await tokenRepository.validateRefreshToken(hash);

        expect(userId, isNull);
      });

      test('returns null for revoked token', () async {
        final hash = 'hash-revoked-${DateTime.now().millisecondsSinceEpoch}';
        await tokenRepository.storeRefreshToken(
          userId: testUserId,
          tokenHash: hash,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
        );

        await tokenRepository.revokeRefreshToken(hash);

        final userId = await tokenRepository.validateRefreshToken(hash);

        expect(userId, isNull);
      });
    });

    group('revokeRefreshToken', () {
      test('revokes a specific token', () async {
        final hash = 'hash-revoke-${DateTime.now().millisecondsSinceEpoch}';
        await tokenRepository.storeRefreshToken(
          userId: testUserId,
          tokenHash: hash,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
        );

        await tokenRepository.revokeRefreshToken(hash);

        final userId = await tokenRepository.validateRefreshToken(hash);
        expect(userId, isNull);
      });

      test('does not throw when revoking non-existent token', () async {
        await expectLater(
          tokenRepository.revokeRefreshToken('non-existent-hash'),
          completes,
        );
      });
    });

    group('revokeAllUserTokens', () {
      test('revokes all tokens for a user', () async {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final hash1 = 'hash-all-1-$timestamp';
        final hash2 = 'hash-all-2-$timestamp';

        await tokenRepository.storeRefreshToken(
          userId: testUserId,
          tokenHash: hash1,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
        );
        await tokenRepository.storeRefreshToken(
          userId: testUserId,
          tokenHash: hash2,
          expiresAt: DateTime.now().toUtc().add(const Duration(days: 7)),
        );

        await tokenRepository.revokeAllUserTokens(testUserId);

        final userId1 = await tokenRepository.validateRefreshToken(hash1);
        final userId2 = await tokenRepository.validateRefreshToken(hash2);

        expect(userId1, isNull);
        expect(userId2, isNull);
      });
    });
  });
}

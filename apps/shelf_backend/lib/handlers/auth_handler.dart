import 'dart:convert';

import 'package:common/models/oauth_data.dart';
import 'package:common/models/user.dart';
import 'package:common/utils/response_body.dart';
import 'package:crypto/crypto.dart';
import 'package:recall_data/recall_data.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_backend/middleware/auth_middleware.dart';
import 'package:shelf_backend/utils/app_response.dart';

class AuthHandler {
  const AuthHandler({
    required UserRepository userRepository,
    required OAuthService oauthService,
    required JwtService jwtService,
    required RefreshTokenRepository refreshTokenRepository,
  }) : _userRepository = userRepository,
       _oauthService = oauthService,
       _jwtService = jwtService,
       _refreshTokenRepository = refreshTokenRepository;

  final OAuthService _oauthService;
  final UserRepository _userRepository;
  final JwtService _jwtService;
  final RefreshTokenRepository _refreshTokenRepository;

  static String _hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  Future<Response> getGoogleAuthUrl(Request request) async {
    try {
      final authData = _oauthService.getGoogleAuthUrl();

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'Google auth URL generated',
          data: authData,
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> getGitHubAuthUrl(Request request) async {
    try {
      final authData = _oauthService.getGitHubAuthUrl();

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'GitHub auth URL generated',
          data: authData,
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> handleGoogleCallback(Request request) async {
    try {
      final code = request.requestedUri.queryParameters['code'];
      if (code == null) {
        return _handleErrorRedirect('Authorization code is required');
      }

      final oauthData = await _oauthService.authenticateWithGoogle(code);
      final user = await _findOrCreateUser(oauthData, AuthProvider.google);

      return _issueTokensAndRedirect(user);
    } catch (_) {
      return _handleErrorRedirect('Authentication failed');
    }
  }

  Future<Response> handleGitHubCallback(Request request) async {
    try {
      final code = request.requestedUri.queryParameters['code'];
      if (code == null) {
        return _handleErrorRedirect('Authorization code is required');
      }

      final oauthData = await _oauthService.authenticateWithGitHub(code);
      final user = await _findOrCreateUser(oauthData, AuthProvider.github);

      return _issueTokensAndRedirect(user);
    } catch (_) {
      return _handleErrorRedirect('Authentication failed');
    }
  }

  Future<Response> handleRefresh(Request request) async {
    try {
      final body = await request.readAsString();
      if (body.isEmpty) {
        return AppResponse.badRequest(
          const ResponseBody(
            success: false,
            message: 'Request body is required',
          ),
        );
      }

      final json = jsonDecode(body) as Map<String, dynamic>;
      final refreshToken = json['refreshToken'] as String?;

      if (refreshToken == null || refreshToken.isEmpty) {
        return AppResponse.badRequest(
          const ResponseBody(
            success: false,
            message: 'Refresh token is required',
          ),
        );
      }

      final tokenHash = _hashToken(refreshToken);
      final userId = await _refreshTokenRepository.validateRefreshToken(
        tokenHash,
      );

      if (userId == null) {
        return AppResponse.unauthorized(
          const ResponseBody(
            success: false,
            message: 'Invalid or expired refresh token',
          ),
        );
      }

      // Revoke the old refresh token (rotation)
      await _refreshTokenRepository.revokeRefreshToken(tokenHash);

      final user = await _userRepository.getUserById(userId);
      if (user == null) {
        return AppResponse.unauthorized(
          const ResponseBody(success: false, message: 'User not found'),
        );
      }

      // Issue new token pair
      final accessToken = _jwtService.createAccessToken(user);
      final newRefreshToken = _jwtService.generateRefreshToken();
      final newTokenHash = _hashToken(newRefreshToken);

      await _refreshTokenRepository.storeRefreshToken(
        userId: userId,
        tokenHash: newTokenHash,
        expiresAt: DateTime.now().toUtc().add(JwtService.refreshTokenExpiry),
      );

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'Tokens refreshed successfully',
          data: {
            'accessToken': accessToken,
            'refreshToken': newRefreshToken,
          },
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> handleLogout(Request request) async {
    try {
      final body = await request.readAsString();
      if (body.isEmpty) {
        return AppResponse.badRequest(
          const ResponseBody(
            success: false,
            message: 'Request body is required',
          ),
        );
      }

      final json = jsonDecode(body) as Map<String, dynamic>;
      final refreshToken = json['refreshToken'] as String?;

      if (refreshToken != null && refreshToken.isNotEmpty) {
        final tokenHash = _hashToken(refreshToken);
        await _refreshTokenRepository.revokeRefreshToken(tokenHash);
      }

      return AppResponse.ok(
        const ResponseBody(
          success: true,
          message: 'Logged out successfully',
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> getCurrentUser(Request request) async {
    try {
      final userId = request.userId;
      final user = await _userRepository.getUserById(userId);

      if (user == null) {
        return AppResponse.notFound(
          const ResponseBody(success: false, message: 'User not found'),
        );
      }

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'User retrieved successfully',
          data: user.toMap(),
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<User> _findOrCreateUser(
    OAuthData oauthData,
    AuthProvider provider,
  ) async {
    final existingUser = await _userRepository.getUserByEmail(oauthData.email);

    if (existingUser != null) return existingUser;

    final user = User.fromOAuthData(
      id: oauthData.id,
      email: oauthData.email,
      firstName: oauthData.firstName,
      lastName: oauthData.lastName,
      provider: provider,
      providerId: oauthData.providerId,
      avatarUrl: oauthData.avatarUrl,
    );

    await _userRepository.createUser(user);
    return user;
  }

  Future<Response> _issueTokensAndRedirect(User user) async {
    final accessToken = _jwtService.createAccessToken(user);
    final refreshToken = _jwtService.generateRefreshToken();
    final tokenHash = _hashToken(refreshToken);

    await _refreshTokenRepository.storeRefreshToken(
      userId: user.id,
      tokenHash: tokenHash,
      expiresAt: DateTime.now().toUtc().add(JwtService.refreshTokenExpiry),
    );

    final redirectUrl = Uri.parse(Environment.clientUrl).replace(
      queryParameters: {
        'token': accessToken,
        'refreshToken': refreshToken,
      },
    );

    return AppResponse.found(redirectUri: redirectUrl);
  }

  Response _handleErrorRedirect(String error) {
    final redirectUrl = Uri.parse(
      Environment.clientUrl,
    ).replace(queryParameters: {'error': Uri.encodeComponent(error)});

    return AppResponse.found(redirectUri: redirectUrl);
  }
}

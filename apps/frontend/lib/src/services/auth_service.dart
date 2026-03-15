import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/config/environment.dart';
import 'package:http/http.dart';
import 'package:native_storage/native_storage.dart';
import 'package:url_launcher/url_launcher.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(http: Client(), storage: NativeStorage());
});

class AuthService {
  const AuthService({required Client http, required NativeStorage storage})
    : _http = http,
      _storage = storage;

  final Client _http;
  final NativeStorage _storage;

  String get _baseUrl => Environment.apiUrl;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> signInWithGoogle() async {
    final response = await _http.get(
      Uri.parse('$_baseUrl/auth/google'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get Google auth URL');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final authUrl = data['data']['url'] as String;

    await launchUrl(Uri.parse(authUrl), webOnlyWindowName: '_self');
  }

  Future<void> signInWithGitHub() async {
    final response = await _http.get(
      Uri.parse('$_baseUrl/auth/github'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get GitHub auth URL');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final authUrl = data['data']['url'] as String;

    await launchUrl(Uri.parse(authUrl), webOnlyWindowName: '_self');
  }

  void saveTokens({required String accessToken, String? refreshToken}) {
    _storage.write(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      _storage.write(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> signOut() async {
    final refreshToken = getRefreshToken();

    if (refreshToken != null) {
      try {
        await _http.post(
          Uri.parse('$_baseUrl/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );
      } catch (_) {}
    }

    _storage.delete(_accessTokenKey);
    _storage.delete(_refreshTokenKey);
  }

  String? getToken() => _storage.read(_accessTokenKey);

  String? getRefreshToken() => _storage.read(_refreshTokenKey);

  Future<String?> refreshAccessToken() async {
    final refreshToken = getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await _http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode != 200) {
        _storage.delete(_accessTokenKey);
        _storage.delete(_refreshTokenKey);
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final responseData = data['data'] as Map<String, dynamic>;

      final newAccessToken = responseData['accessToken'] as String;
      final newRefreshToken = responseData['refreshToken'] as String;

      saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken);

      return newAccessToken;
    } catch (_) {
      return null;
    }
  }
}

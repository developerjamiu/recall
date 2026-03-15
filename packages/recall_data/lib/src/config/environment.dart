import 'package:dotenv/dotenv.dart';

class Environment {
  static final DotEnv _env = DotEnv(
    includePlatformEnvironment: true,
    quiet: true,
  );
  static bool _initialized = false;

  static void init() {
    _env.load();
    _initialized = true;
  }

  static String get(String key, {String? fallback}) {
    assert(_initialized, 'Call Environment.init() first');
    return _env[key] ?? fallback ?? (throw StateError('Missing: $key'));
  }

  static String? getOptional(String key) {
    assert(_initialized, 'Call Environment.init() first');
    return _env[key];
  }

  static String get baseUrl => get('BASE_URL');
  static String get clientUrl => get('CLIENT_URL');

  static String get githubClientId => get('GITHUB_CLIENT_ID');
  static String get githubClientSecret => get('GITHUB_CLIENT_SECRET');

  static String get googleClientId => get('GOOGLE_CLIENT_ID');
  static String get googleClientSecret => get('GOOGLE_CLIENT_SECRET');

  static String get jwtSecret => get('JWT_SECRET');

  static String get dbHost => get('DATABASE_HOST', fallback: 'localhost');
  static String get dbPort => get('DATABASE_PORT', fallback: '5432');
  static String get dbName => get('DATABASE_NAME', fallback: 'recall_dev');
  static String get dbUser => get('DATABASE_USER', fallback: 'recall');
  static String get dbPassword => get('DATABASE_PASSWORD', fallback: 'recall');
}

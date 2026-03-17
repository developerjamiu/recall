/// Database configuration.
///
/// This is the single source of truth for database settings.
/// Used by both the migration CLI and the application runtime.
library;

import 'package:jao/jao.dart';
import 'package:recall_data/src/config/environment.dart';

/// Database configuration.
final databaseConfig = DatabaseConfig.postgres(
  database: Environment.dbName,
  username: Environment.dbUser,
  password: Environment.dbPassword,
  host: Environment.dbHost,
  port: int.parse(Environment.dbPort),
);

/// Database adapter.
const databaseAdapter = PostgresAdapter();

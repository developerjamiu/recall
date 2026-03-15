import 'package:jao/jao.dart';
import 'package:recall_data/src/config/environment.dart';

final databaseConfig = DatabaseConfig.postgres(
  database: Environment.dbName,
  username: Environment.dbUser,
  password: Environment.dbPassword,
  host: Environment.dbHost,
  port: int.parse(Environment.dbPort),
);

const databaseAdapter = PostgresAdapter();

#!/usr/bin/env dart

/// Project migration CLI.
///
/// Usage:
///   dart run bin/migrate.dart migrate
///   dart run bin/migrate.dart makemigrations
///   dart run bin/migrate.dart status
///   dart run bin/migrate.dart rollback
library;

import 'dart:io';

import 'package:jao_cli/jao_cli.dart';
import 'package:recall_data/recall_data.dart';

import '../lib/migrations/migrations.dart';

void main(List<String> args) async {
  Environment.init();

  final config = MigrationRunnerConfig(
    database: databaseConfig,
    adapter: databaseAdapter,
    migrations: allMigrations,
    modelSchemas: [AppNotes.schema, RefreshTokenEntrys.schema, AppUsers.schema],
    verbose: args.contains('-v') || args.contains('--verbose'),
  );

  final cli = JaoCli(config);
  exit(await cli.run(args));
}

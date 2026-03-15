import 'package:jao/jao.dart';

class CreateTables extends Migration {
  @override
  String get name => 'create_tables';

  @override
  void up(MigrationBuilder builder) {
    builder.createTable('notes', (table) {
      table.uuid('id');
      table.uuidColumn('user_id');
      table.string('title', length: 255);
      table.text('content');
      table.timestampTz('created_at');
      table.timestampTz('updated_at');
    });
    builder.createTable('refresh_tokens', (table) {
      table.uuid('id');
      table.uuidColumn('user_id');
      table.string('token_hash', length: 255);
      table.timestampTz('expires_at');
      table.timestampTz('revoked_at', nullable: true);
      table.timestampTz('created_at');
    });
    builder.createTable('users', (table) {
      table.uuid('id');
      table.string('email', length: 255);
      table.string('first_name', length: 255);
      table.string('last_name', length: 255);
      table.string('provider', length: 255);
      table.string('provider_id', length: 255);
      table.string('avatar_url', length: 255, nullable: true);
      table.timestampTz('created_at');
      table.timestampTz('updated_at');
    });
  }

  @override
  void down(MigrationBuilder builder) {
    builder.dropTable('users');
    builder.dropTable('refresh_tokens');
    builder.dropTable('notes');
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token.dart';

// **************************************************************************
// JaoGenerator
// **************************************************************************

class RefreshTokenEntry$ implements ModelFields<RefreshTokenEntry> {
  const RefreshTokenEntry$();

  final id = const StringFieldRef('id');
  final userId = const StringFieldRef('user_id');
  final tokenHash = const StringFieldRef('token_hash');
  final expiresAt = const DateTimeFieldRef('expires_at');
  final revokedAt = const DateTimeFieldRef('revoked_at');
  final createdAt = const DateTimeFieldRef('created_at');
}

class RefreshTokenEntrys {
  RefreshTokenEntrys._();

  static const $ = RefreshTokenEntry$();
  static bool _registered = false;
  static final Manager<RefreshTokenEntry> _objects =
      Manager<RefreshTokenEntry>();

  static Manager<RefreshTokenEntry> get objects {
    if (!_registered) {
      _registered = true;
      _registerMetadata();
      Jao.registerModel<RefreshTokenEntry>(
        ModelRegistration(
          tableName: tableName,
          pkField: pkField,
          fromRow: fromRow,
          toRow: toRow,
          autoNowAddFields: ['created_at'],
          autoGenerateUuidFields: ['id'],
        ),
      );
    }
    return _objects;
  }

  static const tableName = 'refresh_tokens';
  static const pkField = 'id';
  static const fieldNames = [
    'id',
    'userId',
    'tokenHash',
    'expiresAt',
    'revokedAt',
    'createdAt',
  ];

  static RefreshTokenEntry fromRow(Map<String, dynamic> row) {
    return RefreshTokenEntry()
      ..id = row['id'] as String
      ..userId = row['user_id'] as String
      ..tokenHash = row['token_hash'] as String
      ..expiresAt = dbDateTime(row['expires_at'])
      ..revokedAt = dbDateTimeOrNull(row['revoked_at'])
      ..createdAt = dbDateTime(row['created_at']);
  }

  static Map<String, dynamic> toRow(RefreshTokenEntry model) {
    return {
      'id': model.id,
      'user_id': model.userId,
      'token_hash': model.tokenHash,
      'expires_at': model.expiresAt.toIso8601String(),
      'revoked_at': model.revokedAt?.toIso8601String(),
      'created_at': model.createdAt.toIso8601String(),
    };
  }

  static final schema = ModelSchema(
    className: 'RefreshTokenEntry',
    tableName: 'refresh_tokens',
    fields: [
      ModelFieldSchema(
        name: 'id',
        columnName: 'id',
        dbType: FieldType.uuid,
        nullable: false,
        primaryKey: true,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'userId',
        columnName: 'user_id',
        dbType: FieldType.uuid,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
        foreignKey: ForeignKeyInfo(
          referencedTable: 'app_user',
          referencedColumn: 'id',
        ),
      ),
      ModelFieldSchema(
        name: 'tokenHash',
        columnName: 'token_hash',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'expiresAt',
        columnName: 'expires_at',
        dbType: FieldType.timestampTz,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'revokedAt',
        columnName: 'revoked_at',
        dbType: FieldType.timestampTz,
        nullable: true,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'createdAt',
        columnName: 'created_at',
        dbType: FieldType.timestampTz,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: true,
        autoNow: false,
      ),
    ],
  );

  static void _registerMetadata() {
    ModelRegistry.instance.register(
      ModelMetadata(
        modelType: RefreshTokenEntry,
        tableName: tableName,
        primaryKey: pkField,
        fields: {
          'id': FieldMeta(
            fieldName: 'id',
            columnName: 'id',
            dartType: String,
            nullable: false,
            isPrimaryKey: true,
          ),
          'userId': FieldMeta(
            fieldName: 'userId',
            columnName: 'user_id',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'tokenHash': FieldMeta(
            fieldName: 'tokenHash',
            columnName: 'token_hash',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'expiresAt': FieldMeta(
            fieldName: 'expiresAt',
            columnName: 'expires_at',
            dartType: DateTime,
            nullable: false,
            isPrimaryKey: false,
          ),
          'revokedAt': FieldMeta(
            fieldName: 'revokedAt',
            columnName: 'revoked_at',
            dartType: DateTime,
            nullable: true,
            isPrimaryKey: false,
          ),
          'createdAt': FieldMeta(
            fieldName: 'createdAt',
            columnName: 'created_at',
            dartType: DateTime,
            nullable: false,
            isPrimaryKey: false,
          ),
        },
        relations: {
          'userId': RelationMeta(
            fieldName: 'userId',
            columnName: 'user_id_id',
            relatedModel: AppUser,
            relatedColumn: 'id',
            type: RelationType.foreignKey,
          ),
        },
      ),
    );
  }
}

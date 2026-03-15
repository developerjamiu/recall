// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JaoGenerator
// **************************************************************************

class AppUser$ implements ModelFields<AppUser> {
  const AppUser$();

  final id = const StringFieldRef('id');
  final email = const StringFieldRef('email');
  final firstName = const StringFieldRef('first_name');
  final lastName = const StringFieldRef('last_name');
  final provider = const StringFieldRef('provider');
  final providerId = const StringFieldRef('provider_id');
  final avatarUrl = const StringFieldRef('avatar_url');
  final createdAt = const DateTimeFieldRef('created_at');
  final updatedAt = const DateTimeFieldRef('updated_at');
}

class AppUsers {
  AppUsers._();

  static const $ = AppUser$();
  static bool _registered = false;
  static final Manager<AppUser> _objects = Manager<AppUser>();

  static Manager<AppUser> get objects {
    if (!_registered) {
      _registered = true;
      _registerMetadata();
      Jao.registerModel<AppUser>(
        ModelRegistration(
          tableName: tableName,
          pkField: pkField,
          fromRow: fromRow,
          toRow: toRow,
          autoNowAddFields: ['created_at'],
          autoNowFields: ['updated_at'],
          autoGenerateUuidFields: ['id'],
        ),
      );
    }
    return _objects;
  }

  static const tableName = 'users';
  static const pkField = 'id';
  static const fieldNames = [
    'id',
    'email',
    'firstName',
    'lastName',
    'provider',
    'providerId',
    'avatarUrl',
    'createdAt',
    'updatedAt',
  ];

  static AppUser fromRow(Map<String, dynamic> row) {
    return AppUser()
      ..id = row['id'] as String
      ..email = row['email'] as String
      ..firstName = row['first_name'] as String
      ..lastName = row['last_name'] as String
      ..provider = row['provider'] as String
      ..providerId = row['provider_id'] as String
      ..avatarUrl = row['avatar_url'] as String?
      ..createdAt = dbDateTime(row['created_at'])
      ..updatedAt = dbDateTime(row['updated_at']);
  }

  static Map<String, dynamic> toRow(AppUser model) {
    return {
      'id': model.id,
      'email': model.email,
      'first_name': model.firstName,
      'last_name': model.lastName,
      'provider': model.provider,
      'provider_id': model.providerId,
      'avatar_url': model.avatarUrl,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
    };
  }

  static final schema = ModelSchema(
    className: 'AppUser',
    tableName: 'users',
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
        name: 'email',
        columnName: 'email',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'firstName',
        columnName: 'first_name',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'lastName',
        columnName: 'last_name',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'provider',
        columnName: 'provider',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'providerId',
        columnName: 'provider_id',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'avatarUrl',
        columnName: 'avatar_url',
        dbType: FieldType.varchar,
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
      ModelFieldSchema(
        name: 'updatedAt',
        columnName: 'updated_at',
        dbType: FieldType.timestampTz,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: true,
      ),
    ],
  );

  static void _registerMetadata() {
    ModelRegistry.instance.register(
      ModelMetadata(
        modelType: AppUser,
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
          'email': FieldMeta(
            fieldName: 'email',
            columnName: 'email',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'firstName': FieldMeta(
            fieldName: 'firstName',
            columnName: 'first_name',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'lastName': FieldMeta(
            fieldName: 'lastName',
            columnName: 'last_name',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'provider': FieldMeta(
            fieldName: 'provider',
            columnName: 'provider',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'providerId': FieldMeta(
            fieldName: 'providerId',
            columnName: 'provider_id',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'avatarUrl': FieldMeta(
            fieldName: 'avatarUrl',
            columnName: 'avatar_url',
            dartType: String,
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
          'updatedAt': FieldMeta(
            fieldName: 'updatedAt',
            columnName: 'updated_at',
            dartType: DateTime,
            nullable: false,
            isPrimaryKey: false,
          ),
        },
        relations: {},
      ),
    );
  }
}

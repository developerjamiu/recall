// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JaoGenerator
// **************************************************************************

class AppNote$ implements ModelFields<AppNote> {
  const AppNote$();

  final id = const StringFieldRef('id');
  final userId = const StringFieldRef('user_id');
  final title = const StringFieldRef('title');
  final content = const StringFieldRef('content');
  final createdAt = const DateTimeFieldRef('created_at');
  final updatedAt = const DateTimeFieldRef('updated_at');
}

class AppNotes {
  AppNotes._();

  static const $ = AppNote$();
  static bool _registered = false;
  static final Manager<AppNote> _objects = Manager<AppNote>();

  static Manager<AppNote> get objects {
    if (!_registered) {
      _registered = true;
      _registerMetadata();
      Jao.registerModel<AppNote>(
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

  static const tableName = 'notes';
  static const pkField = 'id';
  static const fieldNames = [
    'id',
    'userId',
    'title',
    'content',
    'createdAt',
    'updatedAt',
  ];

  static AppNote fromRow(Map<String, dynamic> row) {
    return AppNote()
      ..id = row['id'] as String
      ..userId = row['user_id'] as String
      ..title = row['title'] as String
      ..content = row['content'] as String
      ..createdAt = dbDateTime(row['created_at'])
      ..updatedAt = dbDateTime(row['updated_at']);
  }

  static Map<String, dynamic> toRow(AppNote model) {
    return {
      'id': model.id,
      'user_id': model.userId,
      'title': model.title,
      'content': model.content,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
    };
  }

  static final schema = ModelSchema(
    className: 'AppNote',
    tableName: 'notes',
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
        name: 'title',
        columnName: 'title',
        dbType: FieldType.varchar,
        nullable: false,
        primaryKey: false,
        autoIncrement: false,
        autoNowAdd: false,
        autoNow: false,
      ),
      ModelFieldSchema(
        name: 'content',
        columnName: 'content',
        dbType: FieldType.text,
        nullable: false,
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
        modelType: AppNote,
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
          'title': FieldMeta(
            fieldName: 'title',
            columnName: 'title',
            dartType: String,
            nullable: false,
            isPrimaryKey: false,
          ),
          'content': FieldMeta(
            fieldName: 'content',
            columnName: 'content',
            dartType: String,
            nullable: false,
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

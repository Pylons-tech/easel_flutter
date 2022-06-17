// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DraftDao? _draftDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `draft` (`id` INTEGER NOT NULL, `imageString` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DraftDao get draftDao {
    return _draftDaoInstance ??= _$DraftDao(database, changeListener);
  }
}

class _$DraftDao extends DraftDao {
  _$DraftDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _draftInsertionAdapter = InsertionAdapter(
            database,
            'draft',
            (Draft item) => <String, Object?>{
                  'id': item.id,
                  'imageString': item.imageString
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Draft> _draftInsertionAdapter;

  @override
  Future<List<Draft>> findAllDrafts() async {
    return _queryAdapter.queryList('SELECT * FROM draft',
        mapper: (Map<String, Object?> row) =>
            Draft(row['id'] as int, row['imageString'] as String));
  }

  @override
  Stream<Draft?> findDraftById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM drafts WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Draft(row['id'] as int, row['imageString'] as String),
        arguments: [id],
        queryableName: 'draft',
        isView: false);
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM drafts WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertDraft(Draft drafts) async {
    await _draftInsertionAdapter.insert(drafts, OnConflictStrategy.abort);
  }
}

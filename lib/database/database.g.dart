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

  ActivityDao? _activityDaoInstance;

  SleepDao? _sleepDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Activity` (`id` INTEGER NOT NULL, `day` INTEGER NOT NULL, `steps` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Sleep` (`day` INTEGER NOT NULL, `deep` INTEGER NOT NULL, `light` INTEGER NOT NULL, `rem` INTEGER NOT NULL, `wake` INTEGER NOT NULL, PRIMARY KEY (`day`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ActivityDao get activityDao {
    return _activityDaoInstance ??= _$ActivityDao(database, changeListener);
  }

  @override
  SleepDao get sleepDao {
    return _sleepDaoInstance ??= _$SleepDao(database, changeListener);
  }
}

class _$ActivityDao extends ActivityDao {
  _$ActivityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _activityInsertionAdapter = InsertionAdapter(
            database,
            'Activity',
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'day': _dateTimeConverter.encode(item.day),
                  'steps': item.steps
                }),
        _activityDeletionAdapter = DeletionAdapter(
            database,
            'Activity',
            ['id'],
            (Activity item) => <String, Object?>{
                  'id': item.id,
                  'day': _dateTimeConverter.encode(item.day),
                  'steps': item.steps
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Activity> _activityInsertionAdapter;

  final DeletionAdapter<Activity> _activityDeletionAdapter;

  @override
  Future<List<Activity>> findAllSteps() async {
    return _queryAdapter.queryList('SELECT * FROM Activity',
        mapper: (Map<String, Object?> row) => Activity(row['id'] as int,
            _dateTimeConverter.decode(row['day'] as int), row['steps'] as int));
  }

  @override
  Future<void> insertActivity(Activity step) async {
    await _activityInsertionAdapter.insert(step, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteActivity(Activity step) async {
    await _activityDeletionAdapter.delete(step);
  }
}

class _$SleepDao extends SleepDao {
  _$SleepDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sleepInsertionAdapter = InsertionAdapter(
            database,
            'Sleep',
            (Sleep item) => <String, Object?>{
                  'day': _dateTimeConverter.encode(item.day),
                  'deep': item.deep,
                  'light': item.light,
                  'rem': item.rem,
                  'wake': item.wake
                }),
        _sleepDeletionAdapter = DeletionAdapter(
            database,
            'Sleep',
            ['day'],
            (Sleep item) => <String, Object?>{
                  'day': _dateTimeConverter.encode(item.day),
                  'deep': item.deep,
                  'light': item.light,
                  'rem': item.rem,
                  'wake': item.wake
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Sleep> _sleepInsertionAdapter;

  final DeletionAdapter<Sleep> _sleepDeletionAdapter;

  @override
  Future<List<Sleep>> findAllSleepstages() async {
    return _queryAdapter.queryList('SELECT * FROM Sleep',
        mapper: (Map<String, Object?> row) => Sleep(
            _dateTimeConverter.decode(row['day'] as int),
            row['deep'] as int,
            row['light'] as int,
            row['rem'] as int,
            row['wake'] as int));
  }

  @override
  Future<Sleep?> findSleepByday(DateTime day) async {
    return _queryAdapter.query('SELECT * FROM Sleep WHERE day = ?1',
        mapper: (Map<String, Object?> row) => Sleep(
            _dateTimeConverter.decode(row['day'] as int),
            row['deep'] as int,
            row['light'] as int,
            row['rem'] as int,
            row['wake'] as int),
        arguments: [_dateTimeConverter.encode(day)]);
  }

  @override
  Future<void> insertSleepstages(Sleep stage) async {
    await _sleepInsertionAdapter.insert(stage, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSleepstages(Sleep stage) async {
    await _sleepDeletionAdapter.delete(stage);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();

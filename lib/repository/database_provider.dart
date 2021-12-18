import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  final _databaseName = "Imploop.db";
  final _databaseVersion = 1;

  // make this singleton class
  DBProvider._();
  static final DBProvider instance = DBProvider._();

  // only have a single app-wide reference to the database
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  void _createTable(Batch batch) {
    const List<String> _queryList = _initializeQuery;

    for (var _query in _queryList) {
      batch.execute(_query);
    }
  }

  //this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        // テーブル作成
        var batch = db.batch();
        _createTable(batch);
        await batch.commit();
      },
      onConfigure: (db) async {
        // 外部キー制約を有効化
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }
}

const List<String> _initializeQuery = [
  '''
      CREATE TABLE task(
        task_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        status_id INTEGER NOT NULL DEFAULT 1,
        foreign key (status_id) references status(status_id)
      )''',
  '''
      CREATE TABLE todo(
        todo_id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        status_id INTEGER NOT NULL DEFAULT 1,
        estimate INTEGER NOT NULL,
        elapsed INTEGER DEFAULT NULL,
        foreign key (task_id) references task(task_id) on delete cascade
        foreign key (status_id) references status(status_id)
      )''',
  '''
      CREATE TABLE status(
        status_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )''',
  '''
      INSERT INTO status (name) VALUES('todo'), ('doing'), ('done')
      '''
  // '''
  // CREATE TABLE task_notice(
  //   task_notice_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   task_id INTEGER NOT NULL,
  //   body TEXT NOT NULL
  // )''',
  // '''
  // CREATE TABLE todo_notice(
  //   todo_notice_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   todo_id INTEGER NOT NULL,
  //   body TEXT NOT NULL
  // )''',
  // '''
  // CREATE TABLE tag(
  //   tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   name TEXT NOT NULL
  // )''',
  // '''
  // CREATE TABLE task_notice_tag(
  //   task_notice_id INTEGER,
  //   tag_id INTEGER
  // )''',
  // '''
  // CREATE TABLE todo_notice_tag(
  //   todo_notice_id INTEGER,
  //   tag_id INTEGER
  // )''',
];

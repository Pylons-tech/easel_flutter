
import 'dart:async';
import 'package:easel_flutter/datasources/dao.dart';
import 'package:easel_flutter/models/draft.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Draft])
abstract class AppDatabase extends FloorDatabase {
  DraftDao get draftDao;
}
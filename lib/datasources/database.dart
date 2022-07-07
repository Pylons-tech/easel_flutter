import 'dart:async';
import 'package:easel_flutter/datasources/nft_dao.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [NFT])
abstract class AppDatabase extends FloorDatabase {
  NftDao get nftDao;
}

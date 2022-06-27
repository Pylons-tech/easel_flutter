import 'package:easel_flutter/models/nft.dart';
import 'package:floor/floor.dart';

@dao
abstract class NftDao {
  @Query('SELECT * FROM nft')
  Future<List<NFT>> findAllNft();

  @Query('SELECT * FROM nft WHERE id = :id')
  Stream<NFT?> findNftById(int id);

  @insert
  Future<void> insertNft(NFT drafts);

  @Query('DELETE FROM nft WHERE id = :id')
  Future<void> delete(int id);
}

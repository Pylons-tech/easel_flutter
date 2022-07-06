import 'package:easel_flutter/models/nft.dart';
import 'package:floor/floor.dart';

@dao
abstract class NftDao {
  @Query('SELECT * FROM nft')
  Future<List<NFT>> findAllNft();

  @Query('SELECT * FROM nft WHERE id = :id')
  Stream<NFT?> findNftById(int id);

  @insert
  Future<int> insertNft(NFT nft);

  @Query('DELETE FROM nft WHERE id = :id')
  Future<void> delete(int id);

  @Query('UPDATE nft SET name = :nftName, description= :nftDescription, creator = :creatorName, step = :step WHERE id = :id')
  Future<void> updateNFTFromDescription(int id, String nftName, String nftDescription, String creatorName, String step);

  @Query('UPDATE nft SET tradePercentage = :tradePercentage, price= :price, quantity = :quantity, denom =:denom, step = :step WHERE id = :id')
  Future<void> updateNFTFromPrice(int id, String tradePercentage, String price, String quantity, String step, String denom);
}

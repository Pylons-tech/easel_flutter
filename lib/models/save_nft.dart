class SaveNft {
  final int? id;
  final String? nftName;
  final String? nftDescription;
  final String? creatorName;
  final String? tradePercentage;
  final String? price;
  final String? quantity;
  final String? denomName;
  final bool? isFreeDrop;
  final String? step;

  SaveNft({this.id, this.isFreeDrop, this.price, this.tradePercentage, this.quantity, this.denomName, this.step, this.creatorName, this.nftDescription, this.nftName});
}

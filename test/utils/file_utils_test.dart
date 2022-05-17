import 'package:easel_flutter/utils/file_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create dynamic link for purchase', () {
    String recipeId = "testRecipe";
    String cookbookId = "cookbookId";

    String expectedDynamicLink = 'https://wallet.pylons.tech/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId';

    var dynamicLink = FileUtils.generateEaselLink(recipeId: recipeId, cookbookId: cookbookId);
    expect(expectedDynamicLink, dynamicLink);
  });
}

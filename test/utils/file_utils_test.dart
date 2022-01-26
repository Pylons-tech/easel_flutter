import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/file_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should create dynamic link for purchase', () {
    String recipeId = "testRecipe";
    String cookbookId = "cookbookId";

    String expectedDynamicLink =
        "https://pylons.page.link/?amv=1&apn=$kWalletAndroidId&ibi=$kWalletIOSId&imv=1&link=https%3A%2F%2Fwallet.pylons.tech%2F%3Faction%3Dpurchase_nft%26recipe_id%3D$recipeId%26cookbook_id%3D$cookbookId%26nft_amount%3D1";

    var dynamicLink = FileUtils.generateEaselLink(recipeId: recipeId, cookbookId: cookbookId);

    expect(expectedDynamicLink, dynamicLink);
  });
}

public with sharing class PA_FavoriteService {
    public void addToFavorites(String productId) {
        FavoriteProduct__c favoriteProduct = new FavoriteProduct__c();
        favoriteProduct.Product__c = productId;
        insert favoriteProduct;
    }
}
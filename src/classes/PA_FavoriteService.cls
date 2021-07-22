public with sharing class PA_FavoriteService {
    public static void addToFavorites(String productId) {
        FavoriteProduct__c result = checkIfExists(productId);
        if (result == null) {
            FavoriteProduct__c favoriteProduct = new FavoriteProduct__c();
            favoriteProduct.Product__c = productId;
            insert favoriteProduct;
        } else {
            throw new DmlException('Product already in watch list.');
        }
    }

    private static FavoriteProduct__c checkIfExists(String productId) {
        String userId = UserInfo.getUserId();
        List<FavoriteProduct__c> favoriteProducts = [
                SELECT Id
                FROM FavoriteProduct__c
                WHERE CreatedById = :userId AND
                Product__c = :productId
                LIMIT 1
        ];
        if (!favoriteProducts.isEmpty()) {
            return favoriteProducts.get(0);
        }
        return null;
    }

    public static PA_PaginationResponse getFavorites(Integer page, Integer pageSize) {
        Integer offset = (page - 1) * pageSize;
        String userId = UserInfo.getUserId();
        List<FavoriteProduct__c> favorites = [
                SELECT Id, Product__c, Product__r.Name, Product__r.Price__c
                FROM FavoriteProduct__c
                WHERE CreatedById = :userId
                LIMIT :pageSize
                OFFSET :offset
        ];
        List<Product__c> mapped = mapToProducts(favorites);
        List<PA_ProductWrapper> wrappers = new PA_ProductWrapperBuilder(mapped)
                .images()
                .discount()
                .watchListNotifications()
                .build();
        return new PA_PaginationResponse(page, getNumberOfFavorites(), wrappers, pageSize);
    }

    public static void toggleNotifications(String productId) {
        String userId = UserInfo.getUserId();
        FavoriteProduct__c favoriteProduct = [
                SELECT Id, Notifications__c
                FROM FavoriteProduct__c
                WHERE CreatedById = :userId AND
                Product__c = :productId
                LIMIT 1
        ];
        if(favoriteProduct != null) {
            if(favoriteProduct.Notifications__c == true) {
                favoriteProduct.Notifications__c = false;
                update favoriteProduct;
                return;
            }
            favoriteProduct.Notifications__c = true;
            update favoriteProduct;
        }
    }

    private static List<Product__c> mapToProducts(List<FavoriteProduct__c> favorites) {
        List<Product__c> result = new List<Product__c>();
        for(FavoriteProduct__c favorite : favorites) {
            Product__c product = new Product__c();
            product.Id = favorite.Product__c;
            product.Name = favorite.Product__r.Name;
            product.Price__c = favorite.Product__r.Price__c;
            result.add(product);
        }
        return result;
    }

    private static Integer getNumberOfFavorites() {
        String userId = UserInfo.getUserId();
        AggregateResult result = [
                SELECT count(Id) size
                FROM FavoriteProduct__c
                WHERE CreatedById = :userId
        ];
        return (Integer) result.get('size');
    }

    public static void removeFromFavorites(String productId) {
        String userId = UserInfo.getUserId();
        List<FavoriteProduct__c> favorites = [
                SELECT Id
                FROM FavoriteProduct__c
                WHERE CreatedById = :userId AND
                Product__c = :productId
        ];
        delete favorites;
    }
}
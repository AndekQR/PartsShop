public class PA_DataProvider {

    @AuraEnabled
    public static List<Product__c> searchProducts(String searchQuery, Integer page) {
        return PA_DataProviderService.searchMoviesLocally(searchQuery, page);
    }

    @AuraEnabled
    public static List<ProductCategory__c> getAllProductCategories() {
        return PA_DataProviderService.getAllProductCategories();
    }

    @AuraEnabled
    public static void saveProduct(Product__c product,
            Map<String, String> imagesData,
            Map<String, String> specs) {
        System.debug('saveProduct DataProvider');
        System.debug(imagesData);
        new PA_DataProviderService().saveProduct(product, imagesData, specs);
    }

    @AuraEnabled
    public static void addToFavorites(String productId) {
        PA_DataProviderService.addToFavorites(productId);
    }
}
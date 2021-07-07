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
            List<String> imageUrls,
            Map<String, String> specs) {
        PA_DataProviderService.saveProduct(product, imageUrls, specs);
    }
}
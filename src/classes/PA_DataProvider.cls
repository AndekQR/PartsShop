public class PA_DataProvider {

    @AuraEnabled
    public static PA_PaginationResponse searchProducts(String searchQuery, Integer page) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.searchMoviesLocally(searchQuery, page);
    }

    @AuraEnabled
    public static List<ProductCategory__c> getAllProductCategories() {
        return PA_DataProviderService.getAllProductCategories();
    }

    @AuraEnabled
    public static void saveProduct(Product__c product,
            Map<String, String> imagesData,
            Map<String, String> specs) {
        PA_DataProviderService service = new PA_DataProviderService();
        service.saveProduct(product, imagesData, specs);
    }

    @AuraEnabled
    public static void addToFavorites(String productId) {
        PA_DataProviderService.addToFavorites(productId);
    }

    @AuraEnabled
    public static PA_PaginationResponse latestProducts(Integer page) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.latestProducts(page);
    }
}
public class PA_DataProvider {

    @AuraEnabled
    public static PA_PaginationResponse searchProducts(String searchQuery, Integer page, Integer pageSize) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.searchMoviesLocally(searchQuery, page, pageSize);
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
    public static PA_PaginationResponse latestProducts(Integer page, Integer pageSize) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.latestProducts(page, pageSize);
    }

    @AuraEnabled
    public static PA_ProductWrapper getProductDetails(String productId) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.getProductDetails(productId);
    }

    @AuraEnabled
    public static void saveReview(String content, String productId, Integer rating) {
        PA_DataProviderService service = new PA_DataProviderService();
        service.saveReview(content, productId, rating);
    }

    @AuraEnabled
    public static PA_PaginationResponse getReviews(String productId, Integer page, Integer pageSize) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.getReviews(productId, page, pageSize);
    }
}
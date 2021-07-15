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
        PA_FavoriteService favoriteService = new PA_FavoriteService();
        favoriteService.addToFavorites(productId);
    }

    @AuraEnabled
    public static void removeFromFavorites(String productId) {
        PA_FavoriteService favoriteService = new PA_FavoriteService();
        favoriteService.removeFromFavorites(productId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getFavorites(Integer page, Integer pageSize) {
        PA_FavoriteService favoriteService = new PA_FavoriteService();
        return favoriteService.getFavorites(page, pageSize);
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

    @AuraEnabled
    public static void addToUserCart(String productId){
        PA_CartService service = new PA_CartService();
        service.addToCart(productId);
    }
    @AuraEnabled
    public static void removeFromCart(String productId){
        PA_CartService service = new PA_CartService();
        service.removeFromCart(productId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getCartsProducts(Integer page, Integer pageSize) {
        PA_CartService service = new PA_CartService();
        return service.getCartsProducts(page, pageSize);
    }

    @AuraEnabled
    public static Cart__c getUserCart() {
        PA_CartService service = new PA_CartService();
        return service.getUserCart();
    }

    @AuraEnabled
    public static void updateProductCartQuantity(String productId, Integer quantity) {
        PA_CartService service = new PA_CartService();
        service.updateProductCartQuantity(productId, quantity);
    }

    @AuraEnabled
    public static PA_PaginationResponse userProducts(Integer page, Integer pageSize) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.userProducts(page, pageSize);
    }
    @AuraEnabled
    public static PA_PaginationResponse getProductsByCategory(Integer page, Integer pageSize, String categoryId) {
        PA_DataProviderService service = new PA_DataProviderService();
        return service.getProductsByCategory(page, pageSize, categoryId);
    }
}
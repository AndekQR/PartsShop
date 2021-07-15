public class PA_DataProvider {

    @AuraEnabled
    public static PA_PaginationResponse searchProducts(String searchQuery, Integer page, Integer pageSize) {
        return PA_DataProviderService.searchMoviesLocally(searchQuery, page, pageSize);
    }

    @AuraEnabled
    public static List<ProductCategory__c> getAllProductCategories() {
        return PA_DataProviderService.getAllProductCategories();
    }

    @AuraEnabled
    public static void saveProduct(Product__c product,
            Map<String, String> imagesData,
            Map<String, String> specs) {
        PA_DataProviderService.saveProduct(product, imagesData, specs);
    }

    @AuraEnabled
    public static void addToFavorites(String productId) {
        PA_FavoriteService.addToFavorites(productId);
    }

    @AuraEnabled
    public static void removeFromFavorites(String productId) {
        PA_FavoriteService.removeFromFavorites(productId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getFavorites(Integer page, Integer pageSize) {
        return PA_FavoriteService.getFavorites(page, pageSize);
    }

    @AuraEnabled
    public static PA_PaginationResponse latestProducts(Integer page, Integer pageSize) {
        return PA_DataProviderService.latestProducts(page, pageSize);
    }

    @AuraEnabled
    public static PA_ProductWrapper getProductDetails(String productId) {
        return PA_DataProviderService.getProductDetails(productId);
    }

    @AuraEnabled
    public static void saveReview(String content, String productId, Integer rating) {
        PA_DataProviderService.saveReview(content, productId, rating);
    }

    @AuraEnabled
    public static PA_PaginationResponse getReviews(String productId, Integer page, Integer pageSize) {
        return PA_DataProviderService.getReviews(productId, page, pageSize);
    }

    @AuraEnabled
    public static void addToUserCart(String productId){
        PA_CartService.addToCart(productId);
    }
    @AuraEnabled
    public static void removeFromCart(String productId){
        PA_CartService.removeFromCart(productId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getCartsProducts(Integer page, Integer pageSize) {
        return PA_CartService.getCartsProducts(page, pageSize);
    }

    @AuraEnabled
    public static Cart__c getUserCart() {
        return PA_CartService.getUserCart();
    }

    @AuraEnabled
    public static void updateProductCartQuantity(String productId, Integer quantity) {
        PA_CartService.updateProductCartQuantity(productId, quantity);
    }

    @AuraEnabled
    public static PA_PaginationResponse userProducts(Integer page, Integer pageSize) {
        return PA_DataProviderService.userProducts(page, pageSize);
    }
    @AuraEnabled
    public static PA_PaginationResponse getProductsByCategory(Integer page, Integer pageSize, String categoryId) {
        return PA_DataProviderService.getProductsByCategory(page, pageSize, categoryId);
    }
}
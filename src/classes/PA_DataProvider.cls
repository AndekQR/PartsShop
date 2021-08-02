public class PA_DataProvider {

    @AuraEnabled
    public static PA_PaginationResponse searchProducts(String searchQuery, Integer page, Integer pageSize) {
        return PA_DataProviderService.searchProductsLocally(searchQuery, page, pageSize);
    }

    @AuraEnabled
    public static List<PA_Category> getAllProductCategories() {
        return PA_DataProviderService.getAllProductCategories();
    }

    @AuraEnabled
    public static void saveProduct(PA_Product product,
            Map<String, String> imagesData,
            Map<String, String> specs) {
        PA_DataProviderService.saveProduct((PA_Product) product, imagesData, specs);
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
    public static void toggleNotifications(String productId) {
        PA_FavoriteService.toggleNotifications(productId);
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
    public static void addToUserCart(String productId, Integer quantity) {
        PA_CartService.addToCart(productId, quantity);
    }
    @AuraEnabled
    public static void removeFromCart(String productId) {
        PA_CartService.removeFromCart(productId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getCartsProducts(Integer page, Integer pageSize) {
        return PA_CartService.getCartsProducts(page, pageSize);
    }

    @AuraEnabled
    public static List<PA_ProductWrapper> getAllProductsCart() {
        return PA_CartService.getAllProductsCart();
    }

    @AuraEnabled
    public static PA_Cart getUserCart() {
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
    public static List<PA_Product> allUserProducts() {
        return PA_DataProviderService.allUserProducts();
    }

    @AuraEnabled
    public static PA_PaginationResponse getProductsByCategory(Integer page, Integer pageSize, String categoryId) {
        return PA_DataProviderService.getProductsByCategory(page, pageSize, categoryId);
    }

    @AuraEnabled
    public static void addDiscount(PA_Discount discount, List<String> productsIds, List<String> usersEmails) {
        PA_DiscountService.addDiscount(discount, productsIds, usersEmails);
    }

    @AuraEnabled
    public static PA_PaginationResponse getDiscountsPage(Integer page, Integer pageSize) {
        PA_DiscountService service = new PA_DiscountService();
        return service.getDiscountsPage(page, pageSize);
    }
    @AuraEnabled
    public static PA_PaginationResponse getRequestedDiscounts(Integer page, Integer pageSize) {
        PA_DiscountService service = new PA_DiscountService();
        return service.getRequestedDiscounts(page, pageSize);
    }

    @AuraEnabled
    public static PA_PaginationResponse getProductsByDiscount(String discountId, Integer page, Integer pageSize) {
        return PA_DiscountService.getProductsByDiscount(discountId, page, pageSize);
    }

    @AuraEnabled
    public static List<String> getDiscountAssignedUsersEmails(String discountId) {
        Set<String> result = PA_DiscountService.getAssignedUserEmails(discountId);
        List<String> toReturn = new List<String>();
        toReturn.addAll(result);
        return toReturn;
    }

    @AuraEnabled
    public static PA_Discount getDiscountFullData(String discountId) {
        return PA_DiscountService.getDiscountFullData(discountId);
    }

    @AuraEnabled
    public static void removeDiscount(String discountId) {
        PA_DiscountService.removeDiscount(discountId);
    }

    @AuraEnabled
    public static List<PA_OrderAddress> getCartAllAddresses() {
        return PA_OrderService.getUserAddresses();
    }

    @AuraEnabled
    public static void createAddress(PA_OrderAddress address) {
        PA_OrderService.createAddress(address);
    }

    @AuraEnabled
    public static void removeAddress(String addressId) {
        PA_OrderService.removeAddress(addressId);
    }

    @AuraEnabled
    public static void makeOrder(String addressId) {
        PA_OrderService.createOrder(addressId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getUsersOrders(Integer page, Integer pageSize) {
        return PA_OrderService.getOrders(page, pageSize);
    }

    @AuraEnabled
    public static void saveCase(PA_Case caseToSave) {
        PA_CaseService.saveCase(caseToSave);
    }

    @AuraEnabled
    public static PA_Case getCase(String caseId) {
        return PA_CaseService.getCase(caseId);
    }

    @AuraEnabled
    public static PA_Discount getDiscount(String discountId) {
        return PA_DiscountService.getDiscount(discountId);
    }

    @AuraEnabled
    public static PA_PaginationResponse getAllDiscounts(Integer page, Integer pageSize) {
        return PA_DiscountService.getAllDiscounts(page, pageSize);
    }
}
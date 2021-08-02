public with sharing class PA_CartService extends PA_Service {

    public static void addToCart(String productId, Integer quantity) {
        PA_Cart userCart = getUserCart();
        if (quantity == null || quantity < 1) {
            quantity = 1;
        }
        ProductCart__c productCart = checkIfExists(productId, userCart.Id);
        if (productCart != null) {
            productCart.Quantity__c += quantity;
            update productCart;
        } else {
            ProductCart__c newProductCart = new ProductCart__c();
            newProductCart.ProductStnd__c = productId;
            newProductCart.Cart__c = userCart.id;
            newProductCart.Quantity__c = quantity;
            insert newProductCart;
        }
    }

    private static ProductCart__c checkIfExists(String productId, String cartId) {
        List<ProductCart__c> result = [
                SELECT Id, Quantity__c
                FROM ProductCart__c
                WHERE Cart__c = :cartId AND
                ProductStnd__c = :productId
                LIMIT 1
        ];
        if (!result.isEmpty()) {
            return result.get(0);
        }
        return null;
    }

    public static void removeFromCart(String productId) {
        List<ProductCart__c> productCarts = [
                SELECT Id
                FROM ProductCart__c
                WHERE CreatedById = :UserInfo.getUserId() AND
                ProductStnd__c = :productId
        ];
        delete productCarts;
    }

    public static PA_PaginationResponse getCartsProducts(Integer page, Integer pageSize) {
        PA_Cart cart = getUserCart();
        Integer offset = (page - 1) * pageSize;
        List<ProductCart__c> productCarts = [
                SELECT Id, ProductStnd__r.Id,ProductStnd__r.Name,
                        ProductStnd__r.Description,
                        ProductStnd__r.ProductCategory__r.Name,
                        ProductStnd__r.Quantity__c,
                        Quantity__c
                FROM ProductCart__c
                WHERE Cart__c = :cart.id
                LIMIT :pageSize
                OFFSET :offset
        ];
        List<Product2> mapped = mapToProducts(productCarts);
        List<PA_ProductWrapper> wrappers = new PA_ProductWrapperBuilder(mapped)
                .images()
                .discount()
                .cartQuantity(productCarts)
                .build();
        return new PA_PaginationResponse(page, getNumberProductsCart(), wrappers, pageSize);
    }

    public static List<PA_ProductWrapper> getAllProductsCart() {
        PA_Cart cart = getUserCart();
        List<ProductCart__c> productCarts = [
                SELECT Id, ProductStnd__r.Id, ProductStnd__r.Name,
                        ProductStnd__r.Description,
                        ProductStnd__r.ProductCategory__r.Name,
                        ProductStnd__r.Quantity__c,
                        Quantity__c
                FROM ProductCart__c
                WHERE Cart__c = :cart.id
        ];
        List<Product2> mapped = mapToProducts(productCarts);
        List<PA_ProductWrapper> wrappers = new PA_ProductWrapperBuilder(mapped)
                .discount()
                .cartQuantity(productCarts)
                .build();
        return wrappers;
    }

    public static void removeCurrentCart() {
        PA_Cart cart = getUserCart();
        delete PA_Cart.mapToCustomCart(cart);
    }

    public static PA_Cart getUserCart() {
        List<Cart__c> carts = [
                SELECT Id, Price_Sum__c, Type__c
                FROM Cart__c
                WHERE CreatedById = :UserInfo.getUserId()
        ];
        if (carts.isEmpty()) {
            Cart__c cart = new Cart__c();
            insert cart;
            return new PA_Cart(cart);
        }
        return new PA_Cart(carts.get(0));
    }

    private static List<Product2> mapToProducts(List<ProductCart__c> productCarts) {
        List<Product2> products = new List<Product2>();
        for (ProductCart__c productCart : productCarts) {
            ProductCategory__c category = new ProductCategory__c();
            category.Name = productCart.ProductStnd__r.ProductCategory__r.Name;
            Product2 product = new Product2();
            product.Id = productCart.ProductStnd__r.Id;
            product.Name = productCart.ProductStnd__r.Name;
            product.Description = productCart.ProductStnd__r.Description;
            product.Quantity__c = productCart.ProductStnd__r.Quantity__c;
            product.ProductCategory__r = category;
            products.add(product);
        }
        return products;
    }

    private static Integer getNumberProductsCart() {
        PA_Cart cart = getUserCart();
        AggregateResult result = [
                SELECT count(Id) size
                FROM ProductCart__c
                WHERE Cart__c = :cart.id
        ];
        return (Integer) result.get('size');
    }

    public static void updateProductCartQuantity(String productId, Integer quantity) {
        PA_Cart cart = getUserCart();
        List<ProductCart__c> productCarts = [
                SELECT Id, Quantity__c, ProductStnd__c
                FROM ProductCart__c
                WHERE Cart__c = :cart.id
        ];
        for (ProductCart__c productCart : productCarts) {
            if (productCart.ProductStnd__c == productId) {
                productCart.Quantity__c = quantity;
                update productCart;
                return;
            }
        }
    }
}
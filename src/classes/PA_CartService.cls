public with sharing class PA_CartService {

    public static void addToCart(String productId) {
        Cart__c userCart = getUserCart();
        ProductCart__c productCart = checkIfExists(productId, userCart.Id);
        if(productCart != null) {
            productCart.Quantity__c += 1;
            update productCart;
        } else {
            ProductCart__c newProductCart = new ProductCart__c();
            newProductCart.Product__c = productId;
            newProductCart.Cart__c = userCart.Id;
            insert newProductCart;
        }
    }

    public static ProductCart__c checkIfExists(String productId, String cartId) {
        List<ProductCart__c> result = [
                SELECT Id, Quantity__c
                FROM ProductCart__c
                WHERE Cart__c = :cartId AND
                Product__c = :productId
                LIMIT 1
        ];
        if(!result.isEmpty()) {
            return result.get(0);
        }
        return null;
    }

    public static void removeFromCart(String productId) {
        List<ProductCart__c> productCarts = [
                SELECT Id
                FROM ProductCart__c
                WHERE CreatedById = :UserInfo.getUserId() AND
                Product__c = :productId
        ];
        delete productCarts;
    }

    public static PA_PaginationResponse getCartsProducts(Integer page, Integer pageSize) {
        Cart__c cart = getUserCart();
        Integer offset = (page - 1) * pageSize;
        List<ProductCart__c> productCarts = [
                SELECT Id, Product__r.Id,Product__r.Name,
                        Product__r.Description__c, Product__r.Price__c,
                        Product__r.ProductCategory__r.Name,
                        Product__r.Rating__c, Product__r.Quantity__c,
                        Quantity__c
                FROM ProductCart__c
                WHERE Cart__c = :cart.Id
                LIMIT :pageSize
                OFFSET :offset
        ];
        List<Product__c> mapped = mapToProducts(productCarts);
        List<PA_ProductWrapper> wrappers = new PA_ProductWrapperBuilder(mapped)
                .images()
                .discount()
                .cartQuantity(productCarts)
                .build();
        return new PA_PaginationResponse(page, getNumberProductsCart(), wrappers, pageSize);
    }

    public static Cart__c getUserCart() {
        List<Cart__c> carts = [
                SELECT Id, Price_Sum__c
                FROM Cart__c
                WHERE CreatedById = :UserInfo.getUserId()
        ];
        if (carts.isEmpty()) {
            Cart__c cart = new Cart__c();
            insert cart;
            return cart;
        }
        return carts.get(0);
    }

    private static List<Product__c> mapToProducts(List<ProductCart__c> productCarts) {
        List<Product__c> products = new List<Product__c>();
        for (ProductCart__c productCart : productCarts) {
            ProductCategory__c category = new ProductCategory__c();
            category.Name = productCart.Product__r.ProductCategory__r.Name;
            Product__c product = new Product__c();
            product.Id = productCart.Product__r.Id;
            product.Name = productCart.Product__r.Name;
            product.Description__c = productCart.Product__r.Description__c;
            product.Price__c = productCart.Product__r.Price__c;
            product.Rating__c = productCart.Product__r.Rating__c;
            product.Quantity__c = productCart.Product__r.Quantity__c;
            product.ProductCategory__r = category;
            products.add(product);
        }
        return products;
    }

    private static Integer getNumberProductsCart() {
        Cart__c cart = getUserCart();
        AggregateResult result = [
                SELECT count(Id) size
                FROM ProductCart__c
                WHERE Cart__c = :cart.Id
        ];
        return (Integer) result.get('size');
    }

    public static void updateProductCartQuantity(String productId, Integer quantity) {
        Cart__c cart = getUserCart();
        List<ProductCart__c> productCarts = [
                SELECT Id, Quantity__c, Product__c
                FROM ProductCart__c
                WHERE Cart__c = :cart.Id
        ];
        for (ProductCart__c productCart : productCarts) {
            if (productCart.Product__c == productId) {
                System.debug('if');
                productCart.Quantity__c = quantity;
                update productCart;
                return;
            }
        }
    }
}
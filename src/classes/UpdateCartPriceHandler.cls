public with sharing class UpdateCartPriceHandler {

    private PA_Service service { get; set; }

    public UpdateCartPriceHandler() {
        this.service = new PA_Service();
    }

    public void handle(List<ProductCart__c> productCarts) {
        Set<String> ids = getCartsIds(productCarts);
        List<ProductCart__c> cartsData = getCartsData(ids);
        List<String> productsIds = getProductsIds(cartsData);
        List<ProductDiscount__c> discounts = service.getDiscounts(productsIds);
        updateCartsPriceSum(cartsData, discounts, ids);
    }

    private List<String> getProductsIds(List<ProductCart__c> productCarts) {
        List<String> result = new List<String>();
        for (ProductCart__c productCart : productCarts) {
            result.add(productCart.Product__c);
        }
        return result;
    }

    private void updateCartsPriceSum(List<ProductCart__c> data, List<ProductDiscount__c> discounts, Set<String> cartsIds) {
        List<Cart__c> cartsToUpdate = new List<Cart__c>();
        for (String cartId : cartsIds) {
            Decimal sum = getPriceSumForCart(data, discounts, cartId);
            Cart__c cart = new Cart__c();
            cart.Id = cartId;
            cart.Price_Sum__c = sum;
            cartsToUpdate.add(cart);
        }
        update cartsToUpdate;
    }

    private Decimal getPriceSumForCart(List<ProductCart__c> data, List<ProductDiscount__c> allDiscounts, String cartId) {
        Decimal result = 0.0;
        for (ProductCart__c productCart : data) {
            if (productCart.Cart__c == cartId) {
                ProductDiscount__c discount = service.findBestProductDiscount(allDiscounts, productCart.Product__c);
                if (discount != null) {
                    result += (productCart.Product__r.Price__c - (productCart.Product__r.Price__c * (discount.Size__c / 100))) * productCart.Quantity__c;
                } else {
                    result += (productCart.Product__r.Price__c) * productCart.Quantity__c;
                }
            }
        }
        return result;
    }

    private List<ProductCart__c> getCartsData(Set<String> cartsIds) {
        List<ProductCart__c> result = [
                SELECT Id, Cart__r.Id, Cart__r.Price_Sum__c, Quantity__c, Product__r.Price__c, Product__r.Name
                FROM ProductCart__c
                WHERE Cart__c IN :cartsIds
        ];
        return result;
    }

    private Set<String> getCartsIds(List<ProductCart__c> productCarts) {
        Set<String> result = new Set<String>();
        for (ProductCart__c productCart : productCarts) {
            result.add(productCart.Cart__c);
        }
        return result;
    }
}
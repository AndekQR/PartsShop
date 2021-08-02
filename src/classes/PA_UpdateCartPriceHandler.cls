public with sharing class PA_UpdateCartPriceHandler {

    private PA_DiscountService service { get; set; }

    public PA_UpdateCartPriceHandler() {
        this.service = new PA_DiscountService();
    }

    public void handle(List<ProductCart__c> productCarts) {
        Set<String> cartsIds = getCartsIds(productCarts);
        List<ProductCart__c> cartsData = getCartsData(cartsIds);
        List<String> productsIds = getProductsIds(cartsData);
        List<PA_Discount> discounts = service.getDiscounts(productsIds);
        List<PricebookEntry> pricebookEntries = getStandardPrices(productsIds);
        updateCartsPriceSum(cartsData, discounts, cartsIds, pricebookEntries);
    }

    private List<PricebookEntry> getStandardPrices(List<String> productsIds) {
        return [
                SELECT Id, UnitPrice, Product2Id
                FROM PricebookEntry
                WHERE Pricebook2.IsStandard = true
                AND Product2Id IN :productsIds
        ];
    }

    private List<String> getProductsIds(List<ProductCart__c> productCarts) {
        List<String> result = new List<String>();
        for (ProductCart__c productCart : productCarts) {
            result.add(productCart.ProductStnd__c);
        }
        return result;
    }

    private void updateCartsPriceSum(List<ProductCart__c> data, List<PA_Discount> discounts, Set<String> cartsIds, List<PricebookEntry> pricebookEntries) {
        List<Cart__c> cartsToUpdate = new List<Cart__c>();
        for (String cartId : cartsIds) {
            Decimal sum = getPriceSumForCart(data, discounts, cartId, pricebookEntries);
            Cart__c cart = new Cart__c();
            cart.Id = cartId;
            cart.Price_Sum__c = sum;
            cartsToUpdate.add(cart);
        }
        update cartsToUpdate;
    }

    private Decimal getPriceSumForCart(List<ProductCart__c> data, List<PA_Discount> allDiscounts, String cartId, List<PricebookEntry> pricebookEntries) {
        Decimal result = 0.0;
        for (ProductCart__c productCart : data) {
            if (productCart.Cart__c == cartId) {
                PA_Discount discount = service.findBestProductDiscount(allDiscounts, productCart.ProductStnd__c);
                Decimal standardPrice = findStandardPrice(pricebookEntries, productCart.ProductStnd__c);
                if (discount != null) {
                    result += (standardPrice - (standardPrice * (discount.size / 100))) * productCart.Quantity__c;
                } else {
                    result += (standardPrice) * productCart.Quantity__c;
                }
            }
        }
        return result;
    }

    private Decimal findStandardPrice(List<PricebookEntry> entries, String productId) {
        for (PricebookEntry pricebookEntry : entries) {
            if(pricebookEntry.Product2Id == productId) {
                return pricebookEntry.UnitPrice;
            }
        }
        return 0;
    }

    private List<ProductCart__c> getCartsData(Set<String> cartsIds) {
        List<ProductCart__c> result = [
                SELECT Id, Cart__r.Id, Cart__r.Price_Sum__c, Quantity__c, ProductStnd__r.Name
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
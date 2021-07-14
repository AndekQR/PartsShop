public class PA_Service {
    public List<ProductDiscount__c> getDiscounts(List<String> productsIds) {
        String userId = UserInfo.getUserId();
        return [
                SELECT Id, Size__c, EndDate__c, ReservedFor__c, Product__c
                FROM ProductDiscount__c
                WHERE (Product__c IN :productsIds) AND
                (
                        ReservedFor__c = :userId OR ReservedFor__c = null
                )
        ];
    }

    public ProductDiscount__c findBestProductDiscount(List<ProductDiscount__c> results, String productId) {
        List<ProductDiscount__c> discounts = new List<ProductDiscount__c>();
        for (ProductDiscount__c result : results) {
            if (result.Product__c == productId) {
                discounts.add(result);
            }
        }
        return findBestDiscount(discounts);
    }

    private ProductDiscount__c findBestDiscount(List<ProductDiscount__c> discounts) {
        if (!discounts.isEmpty()) {
            ProductDiscount__c best = discounts.get(0);
            for (ProductDiscount__c discount : discounts) {
                if (best.Size__c < discount.Size__c) {
                    best = discount;
                }
            }
            return best;
        }
        return null;
    }
}
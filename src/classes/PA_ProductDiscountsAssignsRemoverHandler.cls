public with sharing class PA_ProductDiscountsAssignsRemoverHandler {
    public static void handle(List<Product_ProductDiscount__c> deletedObjects) {
        List<String> ids = extractIds(deletedObjects);
        List<ProductDiscountAssign__c> assignsToDelete = [
                SELECT Id
                FROM ProductDiscountAssign__c
                WHERE Product_ProductDiscount__c IN :ids
        ];
        delete assignsToDelete;
    }

    private static List<String> extractIds(List<Product_ProductDiscount__c> deletedObjects) {
        List<String> idStrings = new List<String>();
        for (Product_ProductDiscount__c product_productDiscount : deletedObjects) {
            idStrings.add(product_productDiscount.Id);
        }
        return idStrings;
    }
}
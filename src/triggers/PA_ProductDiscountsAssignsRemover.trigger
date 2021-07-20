trigger PA_ProductDiscountsAssignsRemover on Product_ProductDiscount__c (after delete) {
    PA_ProductDiscountsAssignsRemoverHandler.handle(Trigger.old);
}
trigger PA_UpdateCartPrice on ProductCart__c (after insert, after update, after delete, after undelete) {
    PA_UpdateCartPriceHandler updateCartPriceHandler = new PA_UpdateCartPriceHandler();
    if(Trigger.isDelete) {
        updateCartPriceHandler.handle(Trigger.old);
    } else {
        updateCartPriceHandler.handle(Trigger.new);
    }
}
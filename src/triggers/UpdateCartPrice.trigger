trigger UpdateCartPrice on ProductCart__c (after insert, after update, after delete, after undelete) {
    UpdateCartPriceHandler updateCartPriceHandler = new UpdateCartPriceHandler();
    if(Trigger.isDelete) {
        updateCartPriceHandler.handle(Trigger.old);
    } else {
        updateCartPriceHandler.handle(Trigger.new);
    }
}
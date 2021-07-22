public class PA_Cart {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public Decimal priceSum { get; set; }
    @AuraEnabled
    public String type { get; set; }
    @AuraEnabled
    public PA_OrderAddress orderAddress { get; set; }

    public PA_Cart() {
    }

    public PA_Cart(Cart__c cart) {
        this.id = cart.Id;
        this.priceSum = cart.Price_Sum__c;
        this.type = cart.Type__c;
    }

    public static Cart__c mapToCustomCart(PA_Cart cart) {
        Cart__c customCart = new Cart__c();
        customCart.Id = cart.id;
        customCart.Price_Sum__c = cart.priceSum;
        customCart.Type__c = cart.type;
        return customCart;
    }
}
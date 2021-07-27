public class PA_Cart {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public Decimal priceSum { get; set; }
    @AuraEnabled
    public String type { get; set; }
    @AuraEnabled
    public Datetime orderTime { get; set; }

    public PA_Cart() {
    }

    public PA_Cart(Cart__c cart) {
        this.id = cart.Id;
        this.priceSum = cart.Price_Sum__c;
        this.type = cart.Type__c;
    }

    public static List<PA_Cart> mapToCarts(List<Cart__c> carts) {
        List<PA_Cart> result = new List<PA_Cart>();
        for (Cart__c cart : carts) {
            result.add(new PA_Cart(cart));
        }
        return result;
    }

    public static Cart__c mapToCustomCart(PA_Cart cart) {
        Cart__c customCart = new Cart__c();
        customCart.Id = cart.id;
        customCart.Price_Sum__c = cart.priceSum;
        customCart.Type__c = cart.type;
        return customCart;
    }
}
public class PA_Cart {
    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public Decimal priceSum {get; set;}

    public PA_Cart(){}

    public PA_Cart(Cart__c cart) {
        this.id = cart.Id;
        this.priceSum = cart.Price_Sum__c;
    }
}
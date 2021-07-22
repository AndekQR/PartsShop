public class PA_ProductWrapper {
    @AuraEnabled
    public PA_Product product { get; set; }
    @AuraEnabled
    public List<String> images { get; set; }
    @AuraEnabled
    public List<PA_Specification> specifications { get; set; }
    @AuraEnabled
    public PA_Discount bestDiscount { get; set; }
    @AuraEnabled
    public Integer cartQuantity { get; set; }
    @AuraEnabled
    public Decimal average { get; set; }
    @AuraEnabled
    public Integer numberOfReviews { get; set; }
    @AuraEnabled
    public Boolean watchListNotifications { get; set; }
}
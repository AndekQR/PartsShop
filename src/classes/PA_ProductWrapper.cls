public class PA_ProductWrapper {
    @AuraEnabled
    public Product__c product { get; set; }
    @AuraEnabled
    public List<String> images { get; set; }
}
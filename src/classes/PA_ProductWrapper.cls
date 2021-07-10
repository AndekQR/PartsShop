public class PA_ProductWrapper {
    @AuraEnabled
    public Product__c product { get; set; }
    @AuraEnabled
    public List<String> images { get; set; }
    @AuraEnabled
    public List<ProductSpecyfication__c> specyfications { get; set; }
    @AuraEnabled
    public ProductDiscount__c bestDiscount { get; set; }
}
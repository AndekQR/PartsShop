public class PA_ProductWrapper {
    @AuraEnabled
    public Product__c product { get; set; }
    @AuraEnabled
    public List<String> images { get; set; }
    @AuraEnabled
    public List<ProductSpecification__c> specifications { get; set; }
    @AuraEnabled
    public ProductDiscount__c bestDiscount { get; set; }
}
public class PA_Specification {

    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public String name {get; set;}
    @AuraEnabled
    public String value {get; set;}
    @AuraEnabled
    public String productId {get; set;}

    public PA_Specification(){}

    public PA_Specification(ProductSpecification__c specification) {
        this.id = specification.Id;
        this.name = specification.Name;
        this.value = specification.Value__c;
        this.productId = specification.Product__c;
    }

    public static List<PA_Specification> mapToSpecifications(List<ProductSpecification__c> specs) {
        List<PA_Specification> result = new List<PA_Specification>();
        for (ProductSpecification__c spec : specs) {
            result.add(new PA_Specification(spec));
        }
        return result;
    }

}
public class PA_Category {
    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public String name {get; set;}

    public PA_Category(){}

    public PA_Category(ProductCategory__c category) {
        this.id = category.Id;
        this.name = category.Name;
    }

    public static List<PA_Category> mapToCategories(List<ProductCategory__c> categories) {
        List<PA_Category> result = new List<PA_Category>();
        for (ProductCategory__c productCategory : categories) {
            result.add(new PA_Category(productCategory));
        }
        return result;
    }

    public static ProductCategory__c mapToCustomCategory(PA_Category category) {
        ProductCategory__c custom = new ProductCategory__c();
        custom.Id = category.id;
        custom.Name = category.name;
        return custom;
    }
}
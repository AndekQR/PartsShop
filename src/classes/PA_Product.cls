public class PA_Product {
    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public Boolean approved {get; set;}
    @AuraEnabled
    public String description {get; set;}
    @AuraEnabled
    public Decimal price {get; set;}
    @AuraEnabled
    public PA_Category category {get; set;}
    @AuraEnabled
    public Decimal quantity {get; set;}
    @AuraEnabled
    public Decimal rating {get; set;}
    @AuraEnabled
    public String name {get; set;}

    public PA_Product(){}

    public PA_Product(Product__c product) {
        this.id = product.Id;
        this.approved = product.Approved__c;
        this.description = product.Description__c;
        this.price = product.Price__c;
        this.quantity = product.Quantity__c;
        this.rating = product.Rating__c;
        this.name = product.Name;
        if(product.ProductCategory__r != null) {
            this.category = new PA_Category(product.ProductCategory__r);
        }
    }

    public static Product__c mapToCustomProduct(PA_Product product) {
        Product__c custom = new Product__c();
        custom.Id = product.id;
        if(product.approved != null) {
            custom.Approved__c = product.approved;
        }
        custom.Description__c = product.description;
        custom.Price__c = product.price;
        custom.Quantity__c = product.quantity;
        custom.Rating__c = product.rating;
        custom.Name = product.name;
        if(product.category != null) {
            custom.ProductCategory__c = product.category.id;
        }
        return custom;
    }

    public static List<PA_Product> mapToProducts(List<Product__c> products) {
        List<PA_Product> pa_products = new List<PA_Product>();
        for (Product__c product : products) {
            PA_Product newPa_product = new PA_Product(product);
            pa_products.add(newPa_product);
        }
        return pa_products;
    }

}
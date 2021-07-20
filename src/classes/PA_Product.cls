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
//    @AuraEnabled
//    public Decimal rating {get; set;}
    @AuraEnabled
    public String name {get; set;}

    public PA_Product(){}

    public PA_Product(Product__c product) {
        this.id = product.Id;
        this.approved = product.Approved__c;
        this.description = product.Description__c;
        this.price = product.Price__c;
        this.quantity = product.Quantity__c;
//        this.rating = product.Rating__c;
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
//        custom.Rating__c = product.rating;
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
    public static List<PA_Product> mapToProducts(List<Product_ProductDiscount__c> products) {
        List<PA_Product> pa_products = new List<PA_Product>();
        for (Product_ProductDiscount__c product : products) {
            PA_Product newPa_product = new PA_Product();
            newPa_product.id = product.Product__r.Id;
            newPa_product.approved = product.Product__r.Approved__c;
            newPa_product.description = product.Product__r.Description__c;
            newPa_product.price = product.Product__r.Price__c;
            newPa_product.quantity = product.Product__r.Quantity__c;
//            newPa_product.rating = product.Product__r.Rating__c;
            newPa_product.name = product.Product__r.Name;
            if(product.Product__r.ProductCategory__r != null) {
                newPa_product.category = new PA_Category(product.Product__r.ProductCategory__r);
            }
            pa_products.add(newPa_product);
        }
        return pa_products;
    }

}
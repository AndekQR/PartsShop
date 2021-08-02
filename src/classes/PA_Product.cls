public class PA_Product {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public Boolean approved { get; set; }
    @AuraEnabled
    public String description { get; set; }
    @AuraEnabled
    public Decimal price { get; set; }
    @AuraEnabled
    public PA_Category category { get; set; }
    @AuraEnabled
    public Decimal quantity { get; set; }
    @AuraEnabled
    public String name { get; set; }
    @AuraEnabled
    public Boolean caseRelated { get; set; }

    public PA_Product() {
    }

    public PA_Product(MyOrderProduct__c orderItem) {
        this.id = orderItem.ProductStnd__c;
        this.quantity = orderItem.Quantity__c;
        this.name = orderItem.ProductStnd__r.Name;
        this.price = orderItem.UnitPrice__c;
    }

    public PA_Product(Product2 product) {
        this.id = product.Id;
        this.approved = product.Approved__c;
        this.description = product.Description;
        this.price = retrieveStandardPrice(product.Id);
        this.quantity = product.Quantity__c;
        this.name = product.Name;
        if (product.ProductCategory__r != null) {
            this.category = new PA_Category(product.ProductCategory__r);
        }
    }

    public static List<PA_Product> mapToProducts(List<Product2> products) {
        List<PA_Product> pa_products = new List<PA_Product>();
        for (Product2 product : products) {
            PA_Product newPa_product = new PA_Product(product);
            pa_products.add(newPa_product);
        }
        return pa_products;
    }

    public static List<PA_Product> mapToProducts(List<Product_ProductDiscount__c> products) {
        List<PA_Product> pa_products = new List<PA_Product>();
        for (Product_ProductDiscount__c product : products) {
            PA_Product newPa_product = new PA_Product();
            newPa_product.id = product.ProductStnd__c;
            newPa_product.approved = product.ProductStnd__r.Approved__c;
            newPa_product.description = product.ProductStnd__r.Description;
            newPa_product.price = retrieveStandardPrice(product.ProductStnd__c);
            newPa_product.quantity = product.ProductStnd__r.Quantity__c;
            newPa_product.name = product.ProductStnd__r.Name;
            if (product.ProductStnd__r.ProductCategory__r != null) {
                newPa_product.category = new PA_Category(product.ProductStnd__r.ProductCategory__r);
            }
            pa_products.add(newPa_product);
        }
        return pa_products;
    }

    public static Decimal retrieveStandardPrice(String productId) {
        PricebookEntry pricebookEntry = [
                SELECT Id, UnitPrice
                FROM PricebookEntry
                WHERE Pricebook2.IsStandard = true AND
                Product2Id = :productId
                LIMIT 1
        ];
        return pricebookEntry.UnitPrice;
    }

}
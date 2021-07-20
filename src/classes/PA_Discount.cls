public class PA_Discount {

    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public Decimal size {get; set;}
    @AuraEnabled
    public Datetime startDate {get; set;}
    @AuraEnabled
    public Datetime endDate {get; set;}
    @AuraEnabled
    public String productId {get; set;}
    @AuraEnabled
    public String status {get; set;}

    public PA_Discount(){}

    public PA_Discount(Product_ProductDiscount__c discount) {
        this.id = discount.ProductDiscount__c;
        this.size = discount.ProductDiscount__r.Size__c;
        this.startDate = discount.ProductDiscount__r.StartDate__c;
        this.endDate = discount.ProductDiscount__r.EndDate__c;
        this.productId = discount.Product__c;
    }
    public PA_Discount(ProductDiscount__c discount) {
        this.id = discount.Id;
        this.size = discount.Size__c;
        this.startDate = discount.StartDate__c;
        this.endDate = discount.EndDate__c;
    }

    public static List<PA_Discount> mapToDiscounts(List<ProductDiscount__c> discounts) {
        List<PA_Discount> pa_discounts = new List<PA_Discount>();
        for (ProductDiscount__c product_productDiscount : discounts) {
            pa_discounts.add(new PA_Discount(product_productDiscount));
        }
        return pa_discounts;
    }

    public static List<PA_Discount> mapToDiscounts(List<Product_ProductDiscount__c> discounts) {
        List<PA_Discount> pa_discounts = new List<PA_Discount>();
        for (Product_ProductDiscount__c product_productDiscount : discounts) {
            pa_discounts.add(new PA_Discount(product_productDiscount));
        }
        return pa_discounts;
    }

    public static ProductDiscount__c mapToDiscount(PA_Discount discount) {
        ProductDiscount__c productDiscount = new ProductDiscount__c();
        productDiscount.Id = discount.id;
        productDiscount.Size__c = discount.size;
        productDiscount.StartDate__c = discount.startDate;
        productDiscount.EndDate__c = discount.endDate;
        productDiscount.Status__c = discount.status;
        return productDiscount;
    }
}
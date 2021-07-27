public with sharing class PA_Case {

    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String subject { get; set; }
    @AuraEnabled
    public String description { get; set; }
    @AuraEnabled
    public Datetime createdDate { get; set; }
    @AuraEnabled
    public List<PA_Product> relatedProducts { get; set; }
    @AuraEnabled
    public String orderId { get; set; }
    @AuraEnabled
    public String status { get; set; }

    public PA_Case() {
    }
    public PA_Case(Case standardCase) {
        this.id = standardCase.Id;
        this.subject = standardCase.Subject;
        this.description = standardCase.Description;
        this.createdDate = standardCase.CreatedDate;
    }

    public PA_Case(MyOrder__c order) {
        this.id = order.Case__r.Id;
        this.subject = order.Case__r.Subject;
        this.description = order.Case__r.Description;
        this.createdDate = order.Case__r.CreatedDate;
        this.orderId = order.Id;
        this.status = order.Case__r.Status;
        this.relatedProducts = mapToProducts(order.MyOrderProducts__r);
    }

    private List<PA_Product> mapToProducts(List<MyOrderProduct__c> orderProducts) {
        List<PA_Product> pa_products = new List<PA_Product>();
        for (MyOrderProduct__c myOrderProduct : orderProducts) {
            PA_Product pa_product = new PA_Product();
            pa_product.id = myOrderProduct.Product__r.Id;
            pa_product.name = myOrderProduct.Product__r.Name;
            pa_product.caseRelated = myOrderProduct.caseRelated__c;
            pa_products.add(pa_product);
        }
        return pa_products;
    }

    public static Case mapToCase(PA_Case castToMap) {
        Case result = new Case();
        result.Subject = castToMap.subject;
        result.Description = castToMap.description;
        result.ContactId = getCurrentUserContactId();
        result.Status = 'New';
        result.Origin = 'PartsShop';
        return result;
    }

    private static String getCurrentUserContactId() {
        User user = [
                SELECT Id, ContactId
                FROM User
                WHERE Id = :UserInfo.getUserId()
                LIMIT 1
        ];
        if (user.ContactId != null) {
            return user.ContactId;
        }
        throw new IllegalArgumentException('No contact associated with current user');
    }
}
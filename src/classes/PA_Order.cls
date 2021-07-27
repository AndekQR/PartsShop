public with sharing class PA_Order {

    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String city { get; set; }
    @AuraEnabled
    public String country { get; set; }
    @AuraEnabled
    public String postalCode { get; set; }
    @AuraEnabled
    public String street { get; set; }
    @AuraEnabled
    public String state { get; set; }
    @AuraEnabled
    public List<PA_Product> products { get; set; }
    @AuraEnabled
    public Decimal priceSum { get; set; }
    @AuraEnabled
    public Datetime orderTime { get; set; }
    @AuraEnabled
    public String caseId { get; set; }

    public PA_Order() {
    }


    public PA_Order(MyOrderProduct__c orderItem, List<PA_Product> orderProducts) {
        this.id = orderItem.MyOrder__c;
        this.city = orderItem.MyOrder__r.OrderAddress__r.City__c;
        this.country = orderItem.MyOrder__r.OrderAddress__r.Country__c;
        this.postalCode = orderItem.MyOrder__r.OrderAddress__r.PostalCode__c;
        this.street = orderItem.MyOrder__r.OrderAddress__r.Street__c;
        this.state = orderItem.MyOrder__r.OrderAddress__r.State__c;
        this.priceSum = orderItem.MyOrder__r.PriceSum__c;
        this.orderTime = orderItem.MyOrder__r.CreatedDate;
        this.caseId = orderItem.MyOrder__r.Case__c;
        this.products = orderProducts;
    }

    public static List<PA_Order> mapToOrders(List<MyOrderProduct__c> items) {
        List<PA_Order> pa_orders = new List<PA_Order>();
        Set<String> ordersIds = getOrdersIds(items);
        for (String orderId : ordersIds) {
            pa_orders.add(extractOrder(items, orderId));
        }
        return pa_orders;
    }

    private static PA_Order extractOrder(List<MyOrderProduct__c> items, String id) {
        for (MyOrderProduct__c orderItem : items) {
            if (orderItem.MyOrder__c == id) {
                return new PA_Order(orderItem, extractOrderProducts(items, id));
            }
        }
        return null;
    }

    private static List<PA_Product> extractOrderProducts(List<MyOrderProduct__c> items, String orderId) {
        List<PA_Product> result = new List<PA_Product>();
        for (MyOrderProduct__c orderItem : items) {
            if (orderItem.MyOrder__c== orderId) {
                PA_Product product = new PA_Product(orderItem);
                result.add(product);
            }
        }
        return result;
    }

    private static Set<String> getOrdersIds(List<MyOrderProduct__c> orderItems) {
        Set<String> ids = new Set<String>();
        for (MyOrderProduct__c orderItem : orderItems) {
            ids.add(orderItem.MyOrder__c);
        }
        return ids;
    }

}
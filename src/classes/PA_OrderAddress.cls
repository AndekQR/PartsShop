public class PA_OrderAddress {

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

    public PA_OrderAddress(){}

    public PA_OrderAddress(OrderAddress__c orderAddress) {
        this.id = orderAddress.Id;
        this.city = orderAddress.City__c;
        this.state = orderAddress.State__c;
        this.street = orderAddress.Street__c;
        this.country = orderAddress.Country__c;
        this.postalCode = orderAddress.PostalCode__c;
    }

    public static List<PA_OrderAddress> mapToOrderAddresses(List<OrderAddress__c> addresses) {
        List<PA_OrderAddress> pa_orderAddresses = new List<PA_OrderAddress>();
        for (OrderAddress__c orderAddress : addresses) {
            pa_orderAddresses.add(new PA_OrderAddress(orderAddress));
        }
        return pa_orderAddresses;
    }

    public static OrderAddress__c mapToCustomOrderAddress(PA_OrderAddress address) {
        OrderAddress__c orderAddress = new OrderAddress__c();
        orderAddress.Id = address.id;
        orderAddress.City__c = address.city;
        orderAddress.State__c = address.state;
        orderAddress.Street__c = address.street;
        orderAddress.Country__c = address.country;
        orderAddress.PostalCode__c = address.postalCode;
        return orderAddress;
    }
}
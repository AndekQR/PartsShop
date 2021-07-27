public with sharing class PA_OrderService {

    public static PA_PaginationResponse getOrders(Integer page, Integer pageSize) {
        Integer offset = (page - 1) * pageSize;
        List<MyOrderProduct__c> orderItems = [
                SELECT Id, MyOrder__c, Product__r.Name, Quantity__c, UnitPrice__c, TotalPrice__c,
                        MyOrder__r.OrderAddress__r.City__c, MyOrder__r.OrderAddress__r.Country__c, MyOrder__r.OrderAddress__r.PostalCode__c, MyOrder__r.OrderAddress__r.Street__c,
                        MyOrder__r.OrderAddress__r.State__c, MyOrder__r.PriceSum__c, MyOrder__r.CreatedDate, MyOrder__r.Case__c
                FROM MyOrderProduct__c
                WHERE MyOrder__r.CreatedById = :UserInfo.getUserId()
                ORDER BY MyOrder__r.CreatedDate
        ];
        List<PA_Order> orders = PA_Order.mapToOrders(orderItems);
        return new PA_PaginationResponse(page, allUserOrdersCount(), orders, pageSize);
    }

    private static Integer allUserOrdersCount() {
        AggregateResult aggregateResult = [
                SELECT count(Id) ordersSum
                FROM Order
                WHERE CreatedById = :UserInfo.getUserId()
        ];
        return (Integer) aggregateResult.get('ordersSum');
    }

    public static void createAddress(PA_OrderAddress address) {
        OrderAddress__c orderAddress = PA_OrderAddress.mapToCustomOrderAddress(address);
        insert orderAddress;
    }

    public static void removeAddress(String addressId) {
        OrderAddress__c orderAddress = new OrderAddress__c();
        orderAddress.Id = addressId;
        delete orderAddress;
    }

    public static List<PA_OrderAddress> getUserAddresses() {
        List<OrderAddress__c> orderAddresses = [
                SELECT Id, City__c, Country__c, PostalCode__c, State__c, Street__c
                FROM OrderAddress__c
                WHERE CreatedById = :UserInfo.getUserId()
        ];
        return PA_OrderAddress.mapToOrderAddresses(orderAddresses);
    }

    public static void createOrder(String orderAddressId) {
        OrderAddress__c orderAddress = getAddress(orderAddressId);
        PA_Cart cart = PA_CartService.getUserCart();
        MyOrder__c order = new MyOrder__c();
        order.OrderAddress__c = orderAddress.Id;
        order.PriceSum__c = cart.priceSum;
        insert order;

        List<MyOrderProduct__c> items = new List<MyOrderProduct__c>();
        List<PA_ProductWrapper> wrappers = PA_CartService.getAllProductsCart();
        for (PA_ProductWrapper wrapper : wrappers) {
            MyOrderProduct__c orderItem = new MyOrderProduct__c();
            if(wrapper.bestDiscount != null) {
                orderItem.UnitPrice__c = wrapper.product.price - (wrapper.product.price * (wrapper.bestDiscount.size / 100));
            } else {
                orderItem.UnitPrice__c = wrapper.product.price;
            }
            orderItem.Quantity__c = wrapper.cartQuantity;
            orderItem.MyOrder__c = order.Id;
            orderItem.Product__c = wrapper.product.id;
            items.add(orderItem);
        }
        insert items;
        PA_CartService.removeCurrentCart();
    }

    private static OrderAddress__c getAddress(String addressId) {
        return [
                SELECT Id, City__c, Country__c, PostalCode__c, State__c, Street__c
                FROM OrderAddress__c
                WHERE Id = :addressId
                LIMIT 1
        ];
    }
}
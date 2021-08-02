public with sharing class PA_CaseService {

    public static void saveCase(PA_Case caseToSave) {
        Case stndCase = PA_Case.mapToCase(caseToSave);
        stndCase.OwnerId = getQueueId();
        insert stndCase;
        caseToSave.id = stndCase.Id;
        updateOrder(caseToSave);
        updateOrderProducts(caseToSave);
    }

    private static void updateOrder(PA_Case caseToSave) {
        MyOrder__c myOrder = new MyOrder__c();
        myOrder.Id = caseToSave.orderId;
        myOrder.Case__c = caseToSave.Id;
        update myOrder;
    }

    private static void updateOrderProducts(PA_Case caseToSave) {
        List<MyOrderProduct__c> orderProducts = getOrderProducts(caseToSave.orderId);
        for (PA_Product product : caseToSave.relatedProducts) {
            for (MyOrderProduct__c myOrderProduct : orderProducts) {
                if (product.id == myOrderProduct.ProductStnd__c && product.caseRelated != null) {
                    myOrderProduct.caseRelated__c = product.caseRelated;
                }
            }
        }
        update orderProducts;
    }

    private static List<MyOrderProduct__c> getOrderProducts(String orderId) {
        return [
                SELECT Id, caseRelated__c, ProductStnd__c
                FROM MyOrderProduct__c
                WHERE MyOrder__c = :orderId
        ];
    }

    public static PA_Case getCase(String caseId) {
        List<MyOrder__c> myOrders = [
                SELECT Id, Case__r.CreatedDate, Case__r.Subject, Case__r.Description, Case__r.Id, Case__r.Status, (SELECT Id, ProductStnd__r.Name, ProductStnd__r.Id, caseRelated__c FROM MyOrderProducts__r)
                FROM MyOrder__c
                WHERE Case__c = :caseId
                LIMIT 1
        ];
        if (!myOrders.isEmpty()) {
            return new PA_Case(myOrders.get(0));
        }
        throw new IllegalArgumentException('No case related to this order');
    }

    @InvocableMethod(label='Find cases by cases numbers')
    public static List<Results> findCaseByNumber(List<Requests> requests) {
        List<String> ids = new List<String>();
        for (Requests request : requests) {
            ids.add(request.inputId);
        }
        List<Case> cases = [
                SELECT Id, Subject, Status, Description
                FROM Case
                WHERE CaseNumber IN :ids
        ];
        List<Results> results = new List<Results>();
        for (Case caseElement : cases) {
            Results result = new Results();
            result.subject = caseElement.Subject;
            results.add(result);
        }
        return results;
    }

    public static String getQueueId() {
        QueueSobject queueSobject = [
                SELECT Queue.Id
                FROM QueueSobject
                WHERE Queue.Name = 'PartsShop Queue'
                LIMIT 1
        ];
        return queueSobject.Queue.Id;
    }

    public class Requests {
        @InvocableVariable(label='Ids for Input' required=true)
        public String inputId;
    }

    public class Results {
        @InvocableVariable(label='Records for Output' required=true)
        public String subject;
    }
}
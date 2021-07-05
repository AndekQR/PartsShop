public with sharing class PA_DataProviderService {

    private static final Integer PAGE_SIZE_LOCAL = 10;

    public static List<Product__c> searchMoviesLocally(String query, Integer page) {
        Integer offset = (page - 1) * PAGE_SIZE_LOCAL;
        if (page == null) {
            page = 0;
        }
        if (String.isBlank(query)) {
            List<Product__c> products = [
                    SELECT Id,Name,
                            Description__c, Price__c,
                            Rating__c, ShortDescription__c
                    FROM Product__c
                    LIMIT :PAGE_SIZE_LOCAL
                    OFFSET :offset
            ];
            return products;
        }
        List<Product__c> products = [
                SELECT Id,Name,
                        Description__c, Price__c,
                        Rating__c, ShortDescription__c
                FROM Product__c
                WHERE Name LIKE :query + '%'
                LIMIT :PAGE_SIZE_LOCAL
                OFFSET :offset
        ];
        return products;
    }
}
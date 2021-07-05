public class PA_DataProvider {

    @AuraEnabled
    public static List<Product__c> searchProducts(String searchQuery, Integer page) {
        return PA_DataProviderService.searchMoviesLocally(searchQuery, page);
    }
}
public with sharing class PA_DataProviderService {

    private static final Integer PAGE_SIZE_LOCAL = 10;

    public static List<Product__c> searchMoviesLocally(String query, Integer page) {
        if (page == null) {
            page = 1;
        }
        Integer offset = (page - 1) * PAGE_SIZE_LOCAL;
        if (String.isBlank(query)) {
            List<Product__c> products = [
                    SELECT Id,Name,
                            Description__c, Price__c,
                            ProductCategory__c, ProductDiscount__c,
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
                        ProductCategory__c, ProductDiscount__c,
                        Rating__c, ShortDescription__c
                FROM Product__c
                WHERE Name LIKE :query + '%'
                LIMIT :PAGE_SIZE_LOCAL
                OFFSET :offset
        ];
        return products;
    }

    public static List<ProductCategory__c> getAllProductCategories() {
        return [
                SELECT Id, Name
                FROM ProductCategory__c
                ORDER BY Name
        ];
    }

    public static void saveProduct(Product__c product, List<String> imageUrls,
            Map<String, String> specs) {
        insert product;
        List<ProductImage__c> productImages = new List<ProductImage__c>();
        List<ProductSpecyfication__c> productSpecyfications = new List<ProductSpecyfication__c>();
        for (String url : imageUrls) {
            ProductImage__c productImage = new ProductImage__c();
            productImage.Url__c = url.trim();
            productImage.Product__c = product.Id;
            productImages.add(productImage);
        }
        for(String key : specs.keySet()) {
            ProductSpecyfication__c specyfication = new ProductSpecyfication__c();
            specyfication.Name = key.trim();
            specyfication.Value__c = specs.get(key).trim();
            specyfication.Product__c = product.Id;
            productSpecyfications.add(specyfication);
        }
        insert productImages;
        insert productSpecyfications;
    }
}
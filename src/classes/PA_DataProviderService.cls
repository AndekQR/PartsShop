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

    public void saveProduct(Product__c product, Map<String, String> imagesData,
            Map<String, String> specs) {
        insert product;
        List<ProductSpecyfication__c> productSpecyfications = new List<ProductSpecyfication__c>();
        for (String key : specs.keySet()) {
            ProductSpecyfication__c specyfication = new ProductSpecyfication__c();
            specyfication.Name = key.trim();
            specyfication.Value__c = specs.get(key).trim();
            specyfication.Product__c = product.Id;
            productSpecyfications.add(specyfication);
        }
        this.saveImages(imagesData, product.Id);
        insert productSpecyfications;
    }

    private void saveImages(Map<String, String> imagesData, String imagesOwnerId) {
        List<Attachment> attachments = new List<Attachment>();
        for (String fileName : imagesData.keySet()) {
            Attachment attachment = new Attachment();
            attachment.parentId = imagesOwnerId;
            attachment.body = EncodingUtil.base64Decode(imagesData.get(fileName));
            attachment.name = fileName;
            attachments.add(attachment);
        }
        insert attachments;
    }

    private List<Attachment> getImages(String ownerId) {
        return [
                SELECT Id, Name, LastModifiedDate, ContentType
                FROM Attachment
                WHERE parentid = :ownerId
                ORDER BY LastModifiedDate DESC
        ];
    }

    public static void addToFavorites(String productId) {
        FavoriteProduct__c favoriteProduct = new FavoriteProduct__c();
        favoriteProduct.Product__c = productId;
        insert favoriteProduct;
    }

}
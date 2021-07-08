public with sharing class PA_DataProviderService {

    private static final Integer PAGE_SIZE_LOCAL = 1;

    public PA_PaginationResponse searchMoviesLocally(String query, Integer page) {
        if (page == null || page < 1) {
            page = 1;
        }
        PA_ProductWrapper productWrapper = new PA_ProductWrapper();
        Integer offset = (page - 1) * PAGE_SIZE_LOCAL;
        if (String.isBlank(query)) {
            return getProducts(page);
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
        List<Attachment> attachments = getImages(this.getIds(products));
        List<PA_ProductWrapper> wrappers =  PA_ProductWrapper.createWrappers(products, attachments);
        return new PA_PaginationResponse(page, getProductsSize(), wrappers, PAGE_SIZE_LOCAL);
    }

    public PA_PaginationResponse getProducts(Integer page) {
        Integer offset = (page - 1) * PAGE_SIZE_LOCAL;
        List<Product__c> products = [
                SELECT Id,Name,
                        Description__c, Price__c,
                        ProductCategory__c, ProductDiscount__c,
                        Rating__c, ShortDescription__c
                FROM Product__c
                LIMIT :PAGE_SIZE_LOCAL
                OFFSET :offset
        ];
        List<Attachment> attachments = getImages(this.getIds(products));
        List<PA_ProductWrapper> wrappers =  PA_ProductWrapper.createWrappers(products, attachments);
        return new PA_PaginationResponse(page, getProductsSize(), wrappers, PAGE_SIZE_LOCAL);
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
                SELECT Id, Body, ParentId
                FROM Attachment
                WHERE parentid = :ownerId
                ORDER BY LastModifiedDate DESC
        ];
    }

    private Integer getProductsSize() {
        AggregateResult result = [
                SELECT count(Id) size
                FROM Product__c
        ];
        return (Integer) result.get('size');
    }

    private List<Attachment> getImages(List<String> ownersId) {
        List<Attachment> attachments = [
                SELECT Id, Body, ParentId
                FROM Attachment
                WHERE ParentId IN :ownersId
                ORDER BY LastModifiedDate DESC
        ];
        return attachments;
    }

    private List<String> getIds(List<SObject> objects) {
        List<String> result = new List<String>();
        for (SObject ob : objects) {
            result.add(ob.Id);
        }
        return result;
    }

    public static void addToFavorites(String productId) {
        FavoriteProduct__c favoriteProduct = new FavoriteProduct__c();
        favoriteProduct.Product__c = productId;
        insert favoriteProduct;
    }

    public PA_PaginationResponse latestProducts(Integer page) {
        if (page == null || page < 1) {
            page = 1;
        }
        PA_ProductWrapper productWrapper = new PA_ProductWrapper();
        Integer offset = (page - 1) * PAGE_SIZE_LOCAL;
        List<Product__c> products = [
                SELECT Id,Name,
                        Description__c, Price__c,
                        ProductCategory__c, ProductDiscount__c,
                        Rating__c, ShortDescription__c
                FROM Product__c
                ORDER BY CreatedDate DESC
                LIMIT :PAGE_SIZE_LOCAL
                OFFSET :offset

        ];
        List<Attachment> attachments = getImages(this.getIds(products));
        List<PA_ProductWrapper> wrappers =  PA_ProductWrapper.createWrappers(products, attachments);
        return new PA_PaginationResponse(page, getProductsSize(), wrappers, PAGE_SIZE_LOCAL);
    }

}
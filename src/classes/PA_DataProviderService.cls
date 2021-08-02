public with sharing class PA_DataProviderService {

    public static PA_PaginationResponse searchProductsLocally(String query, Integer page, Integer pageSize) {
        page = validatePageData(page, 1);
        pageSize = validatePageData(pageSize, 12);
        PA_ProductWrapper productWrapper = new PA_ProductWrapper();
        Integer offset = (page - 1) * pageSize;
        if (String.isBlank(query)) {
            return getProducts(page, pageSize);
        }
        List<Product2> products = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c, Approved__c
                FROM Product2
                WHERE Name LIKE :query + '%' AND
                Approved__c = :true
                LIMIT :pageSize
                OFFSET :offset
        ];
        PA_ProductWrapperBuilder builder = new PA_ProductWrapperBuilder(products)
                .images()
                .discount();
        return new PA_PaginationResponse(page, getProductsSize(), builder.build(), pageSize);
    }

    public static PA_PaginationResponse getProducts(Integer page, Integer pageSize) {
        Integer offset = (page - 1) * pageSize;
        List<Product2> products = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c, Approved__c
                FROM Product2
                WHERE Approved__c = :true
                LIMIT :pageSize
                OFFSET :offset
        ];
        PA_ProductWrapperBuilder builder = new PA_ProductWrapperBuilder(products)
                .images()
                .discount();
        return new PA_PaginationResponse(page, getProductsSize(), builder.build(), pageSize);
    }

    public static List<PA_Category> getAllProductCategories() {
        List<ProductCategory__c> productCategories = [
                SELECT Id, Name
                FROM ProductCategory__c
                ORDER BY Name
        ];
        return PA_Category.mapToCategories(productCategories);
    }

    public static void saveProduct(PA_Product product, Map<String, String> imagesData,
            Map<String, String> specs) {
        Product2 insertedProduct = insertProduct(product);
        List<ProductSpecification__c> productSpecifications = new List<ProductSpecification__c>();
        for (String key : specs.keySet()) {
            ProductSpecification__c specification = new ProductSpecification__c();
            specification.Name = key.trim();
            specification.Value__c = specs.get(key).trim();
            specification.ProductStnd__c = insertedProduct.Id;
            productSpecifications.add(specification);
        }
        saveImages(imagesData, insertedProduct.Id);
        insert productSpecifications;
    }

    private static Product2 insertProduct(PA_Product product) {
        Product2 product2 = new Product2();
        product2.Description = product.description;
        if(product.category != null) {
            product2.ProductCategory__c = product.category.id;
        }
        product2.Quantity__c = product.quantity;
        product2.Name = product.name;
        insert product2;

        Pricebook2 pricebook = [
                SELECT Id
                FROM Pricebook2
                WHERE IsStandard = true
                LIMIT 1
        ];

        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebook.Id;
        pricebookEntry.Product2Id = product2.Id;
        pricebookEntry.UnitPrice = product.price;
        insert pricebookEntry;

        return product2;
    }

    private static void saveImages(Map<String, String> imagesData, String imagesOwnerId) {
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

    private static List<Attachment> getImages(String ownerId) {
        return [
                SELECT Id, Body, ParentId
                FROM Attachment
                WHERE parentid = :ownerId
                ORDER BY LastModifiedDate DESC
        ];
    }

    private static Integer getProductsSize() {
        AggregateResult result = [
                SELECT count(Id) size
                FROM Product2
                WHERE Approved__c = true
        ];
        return (Integer) result.get('size');
    }
    private static Integer getUserProductsSize() {
        String userId = UserInfo.getUserId();
        AggregateResult result = [
                SELECT count(Id) size
                FROM Product2
                WHERE Approved__c = true AND
                CreatedById = :userId
        ];
        return (Integer) result.get('size');
    }
    private static Integer getProductsSize(String categoryId) {
        AggregateResult result = [
                SELECT count(Id) size
                FROM Product2
                WHERE ProductCategory__c = :categoryId
        ];
        return (Integer) result.get('size');
    }

    private static List<String> getIds(List<SObject> objects) {
        List<String> result = new List<String>();
        for (SObject ob : objects) {
            result.add(ob.Id);
        }
        return result;
    }

    public static PA_PaginationResponse latestProducts(Integer page, Integer pageSize) {
        page = validatePageData(page, 1);
        pageSize = validatePageData(pageSize, 12);
        PA_ProductWrapper productWrapper = new PA_ProductWrapper();
        Integer offset = (page - 1) * pageSize;
        List<Product2> products = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c,Approved__c
                FROM Product2
                WHERE Approved__c = :true
                ORDER BY CreatedDate DESC
                LIMIT :pageSize
                OFFSET :offset

        ];
        PA_ProductWrapperBuilder builder = new PA_ProductWrapperBuilder(products)
                .images()
                .discount();
        return new PA_PaginationResponse(page, getProductsSize(), builder.build(), pageSize);
    }

    public static List<PA_Product> allUserProducts() {
        String userId = UserInfo.getUserId();
        List<Product2> products = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c, Approved__c
                FROM Product2
                WHERE CreatedById = :userId AND
                Approved__c = :true
                ORDER BY Name ASC
        ];
        return PA_Product.mapToProducts(products);
    }

    public static PA_PaginationResponse userProducts(Integer page, Integer pageSize) {
        page = validatePageData(page, 1);
        pageSize = validatePageData(pageSize, 12);
        String userId = UserInfo.getUserId();
        PA_ProductWrapper productWrapper = new PA_ProductWrapper();
        Integer offset = (page - 1) * pageSize;
        List<Product2> products = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c, Approved__c
                FROM Product2
                WHERE CreatedById = :userId AND
                Approved__c = :true
                ORDER BY CreatedDate DESC
                LIMIT :pageSize
                OFFSET :offset

        ];
        PA_ProductWrapperBuilder builder = new PA_ProductWrapperBuilder(products)
                .images()
                .discount();
        return new PA_PaginationResponse(page, getUserProductsSize(), builder.build(), pageSize);
    }
    public static PA_PaginationResponse getProductsByCategory(Integer page, Integer pageSize, String categoryId) {
        page = validatePageData(page, 1);
        pageSize = validatePageData(pageSize, 12);
        PA_ProductWrapper productWrapper = new PA_ProductWrapper();
        Integer offset = (page - 1) * pageSize;
        List<Product2> products = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c, Approved__c
                FROM Product2
                WHERE ProductCategory__c = :categoryId AND
                Approved__c = :true
                ORDER BY CreatedDate DESC
                LIMIT :pageSize
                OFFSET :offset

        ];
        PA_ProductWrapperBuilder builder = new PA_ProductWrapperBuilder(products)
                .images()
                .discount();
        return new PA_PaginationResponse(page, getProductsSize(categoryId), builder.build(), pageSize);
    }

    public static PA_ProductWrapper getProductDetails(String productId) {
        Product2 product = [
                SELECT Id,Name,
                        Description,
                        ProductCategory__r.Name,
                        Quantity__c, Approved__c
                FROM Product2
                WHERE Id = :productId AND
                Approved__c = :true
                LIMIT 1
        ];
        PA_ProductWrapperBuilder builder = new PA_ProductWrapperBuilder(new List<Product2>{
                product
        })
                .images()
                .specifications()
                .rateAverage()
                .discount();
        return builder.build().get(0);
    }

    public static void saveReview(String content, String productId, Integer rating) {
        ProductReview__c review = new ProductReview__c();
        review.Content__c = content;
        review.ProductStnd__c = productId;
        review.Rating__c = rating;
        insert review;
    }

    private static Integer getReviewsSize(String productId) {
        AggregateResult result = [
                SELECT count(Id) size
                FROM ProductReview__c
                WHERE ProductStnd__c = :productId
        ];
        return (Integer) result.get('size');
    }

    public static PA_PaginationResponse getReviews(String productId, Integer page, Integer pageSize) {
        page = validatePageData(page, 1);
        pageSize = validatePageData(pageSize, 12);
        Integer offset = (page - 1) * pageSize;
        List<ProductReview__c> reviews = [
                SELECT Id, Content__c, Rating__c, CreatedDate, CreatedBy.Name, ProductStnd__c
                FROM ProductReview__c
                WHERE ProductStnd__c = :productId
                ORDER BY CreatedDate DESC
                LIMIT :pageSize
                OFFSET :offset
        ];
        return new PA_PaginationResponse(page, getReviewsSize(productId), PA_Review.mapToReviews(reviews), pageSize);
    }

    private static Integer validatePageData(Integer currentValue, Integer defaultValue) {
        if (currentValue == null || currentValue < 1) {
            return defaultValue;
        }
        return currentValue;
    }
}
public class PA_DiscountService extends PA_Service {

    public List<PA_Discount> getDiscounts(List<String> productsIds) {
        String userId = UserInfo.getUserId();
        List<String> product_productDiscountNotAssigned = getProductDiscountNotAssignedToUsers();
        List<String> product_productDiscountAssigned = getIdsProductDiscountAssignedToUser(userId);
        List<Product_ProductDiscount__c> product_productDiscounts = [
                SELECT Id, ProductDiscount__r.Id,
                        ProductDiscount__r.Size__c, ProductDiscount__r.StartDate__c,
                        ProductDiscount__r.EndDate__c, Product__c
                FROM Product_ProductDiscount__c
                WHERE ((ProductDiscount__c IN :product_productDiscountAssigned) OR
                (ProductDiscount__c IN :product_productDiscountNotAssigned)) AND
                Product__c IN :productsIds AND ProductDiscount__r.Status__c = 'Active'
        ];
        return PA_Discount.mapToDiscounts(product_productDiscounts);
    }

    public PA_PaginationResponse getRequestedDiscounts(Integer page, Integer pageSize) {
        Integer offset = (page - 1) * pageSize;
        List<Product_ProductDiscount__c> product_productDiscounts = [
                SELECT Id, ProductDiscount__r.Id,
                        ProductDiscount__r.Size__c, ProductDiscount__r.StartDate__c,
                        ProductDiscount__r.EndDate__c, Product__c
                FROM Product_ProductDiscount__c
                WHERE ProductDiscount__r.Status__c = 'Request'
                LIMIT :pageSize
                OFFSET :offset
        ];
        return new PA_PaginationResponse(
                page,
                countDiscountsRequests(),
                PA_Discount.mapToDiscounts(product_productDiscounts),
                pageSize
        );
    }

    public static PA_Discount getDiscount(String discountId) {
        ProductDiscount__c discount = [
                SELECT Id, Size__c, StartDate__c, EndDate__c
                FROM ProductDiscount__c
                WHERE Id = :discountId
                LIMIT 1
        ];
        return new PA_Discount(discount);
    }

    private Integer countDiscountsRequests() {
        String userId = UserInfo.getUserId();
        AggregateResult result = [
                SELECT count(Id) size
                FROM Product_ProductDiscount__c
                WHERE CreatedById = :userId AND
                ProductDiscount__r.Status__c = 'Request'
        ];
        return (Integer) result.get('size');
    }

    public PA_PaginationResponse getDiscountsPage(Integer page, Integer pageSize) {
        String userId = UserInfo.getUserId();
        Integer offset = (page - 1) * pageSize;
        List<String> productDiscountNotAssigned = getProductDiscountNotAssignedToUsers();
        List<String> productDiscountAssigned = getIdsProductDiscountAssignedToUser(userId);
        List<ProductDiscount__c> product_productDiscounts = [
                SELECT Id,
                        Size__c, StartDate__c,
                        EndDate__c
                FROM ProductDiscount__c
                WHERE ((Id IN :productDiscountAssigned) OR (Id IN :productDiscountNotAssigned)) AND
                Status__c = 'Active'
                LIMIT :pageSize
                OFFSET :offset
        ];
        Integer allRecordCount = productDiscountNotAssigned.size() + productDiscountAssigned.size();
        return new PA_PaginationResponse(
                page,
                allRecordCount,
                PA_Discount.mapToDiscounts(product_productDiscounts),
                pageSize
        );
    }

    public static PA_PaginationResponse getAllDiscounts(Integer page, Integer pageSize) {
        Integer offset = (page - 1) * pageSize;
        List<ProductDiscount__c> discounts = [
                SELECT Id,
                        Size__c, StartDate__c,
                        EndDate__c
                FROM ProductDiscount__c
                WHERE Status__c = 'Active'
                LIMIT :pageSize
                OFFSET :offset
        ];
        return new PA_PaginationResponse(
                page,
                countAllActiveDiscounts(),
                PA_Discount.mapToDiscounts(discounts),
                pageSize
        );
    }

    private static Integer countAllActiveDiscounts() {
        AggregateResult result = [
                SELECT count(Id) size
                FROM ProductDiscount__c
                WHERE Status__c = 'Active'
        ];
        return (Integer) result.get('size');
    }

    public static PA_PaginationResponse getProductsByDiscount(String discountId, Integer page, Integer pageSize) {
        List<Product_ProductDiscount__c> product_productDiscounts = new List<Product_ProductDiscount__c>();
        if (page == null || pageSize == null) {
            product_productDiscounts = [
                    SELECT Id, Product__r.Name, Product__r.Quantity__c, Product__r.Rating__c, Product__r.Id,
                            Product__r.Approved__c, Product__r.Price__c, Product__r.Description__c,
                            Product__r.ProductCategory__r.Name
                    FROM Product_ProductDiscount__c
                    WHERE ProductDiscount__c = :discountId
            ];
        } else {
            Integer offset = (page - 1) * pageSize;
            product_productDiscounts = [
                    SELECT Id, Product__r.Name, Product__r.Quantity__c, Product__r.Rating__c, Product__r.Id,
                            Product__r.Approved__c, Product__r.Price__c, Product__r.Description__c,
                            Product__r.ProductCategory__r.Name
                    FROM Product_ProductDiscount__c
                    WHERE ProductDiscount__c = :discountId
                    LIMIT :pageSize
                    OFFSET :offset
            ];
        }
        List<PA_Product> result = PA_Product.mapToProducts(product_productDiscounts);
        return new PA_PaginationResponse(page, countProductsByDiscount(discountId), result, pageSize);
    }

    public static Set<String> getAssignedUserEmails(String discountId) {
        List<ProductDiscountAssign__c> productDiscountAssigns = [
                SELECT Id, User__r.Email
                FROM ProductDiscountAssign__c
                WHERE Product_ProductDiscount__r.ProductDiscount__c = :discountId
        ];
        Set<String> emails = new Set<String>();
        for (ProductDiscountAssign__c productDiscountAssign : productDiscountAssigns) {
            emails.add(productDiscountAssign.User__r.Email);
        }
        return emails;
    }

    public static Integer countProductsByDiscount(String discountId) {
        String userId = UserInfo.getUserId();
        AggregateResult result = [
                SELECT count(Id) size
                FROM Product_ProductDiscount__c
                WHERE CreatedById = :userId AND
                ProductDiscount__c = :discountId
        ];
        return (Integer) result.get('size');
    }

    private List<String> getProductDiscountNotAssignedToUsers() {
        List<AggregateResult> product_productDiscounts = [
                SELECT ProductDiscount__c
                FROM Product_ProductDiscount__c
                WHERE Id NOT IN (SELECT Product_ProductDiscount__c FROM ProductDiscountAssign__c)
                GROUP BY ProductDiscount__c
        ];
        List<String> ids = new List<String>();
        for (AggregateResult aggregateResult : product_productDiscounts) {
            String id = (String) aggregateResult.get('ProductDiscount__c');
            if (id != null) {
                ids.add(id);
            }
        }
        return ids;
    }

    private List<String> getIdsProductDiscountAssignedToUser(String userId) {
        List<AggregateResult> userDiscountsAssigns = [
                SELECT ProductDiscount__c
                FROM Product_ProductDiscount__c
                WHERE Id IN (SELECT Product_ProductDiscount__c FROM ProductDiscountAssign__c WHERE User__c = :userId)
                GROUP BY ProductDiscount__c
        ];
        List<String> ids = new List<String>();
        for (AggregateResult aggregateResult : userDiscountsAssigns) {
            String id = (String) aggregateResult.get('ProductDiscount__c');
            ids.add(id);
        }
        return ids;
    }


    public PA_Discount findBestProductDiscount(List<PA_Discount> results, String productId) {
        List<PA_Discount> discounts = new List<PA_Discount>();
        for (PA_Discount result : results) {
            if (result.productId == productId && isValidTimeInterval(result)) {
                discounts.add(result);
            }
        }
        return findBestDiscount(discounts);
    }

    private PA_Discount findBestDiscount(List<PA_Discount> discounts) {
        if (!discounts.isEmpty()) {
            PA_Discount best = discounts.get(0);
            for (PA_Discount discount : discounts) {
                if (best.size < discount.size) {
                    best = discount;
                }
            }
            return best;
        }
        return null;
    }

    private Boolean isValidTimeInterval(PA_Discount discount) {
        Datetime now = System.now();
        if (now > discount.startDate && now <= discount.endDate) {
            return true;
        }
        return false;
    }

    public static void addDiscount(PA_Discount discount, List<String> productsIds, List<String> usersEmails) {
        if (discount.id != null) {
            removeDiscount(discount.id);
            discount.id = null;
        }
        ProductDiscount__c mappedDiscount = PA_Discount.mapToDiscount(discount);
        insert mappedDiscount;
        System.debug(mappedDiscount);
        List<Product_ProductDiscount__c> product_productDiscounts = new List<Product_ProductDiscount__c>();
        for (String productId : productsIds) {
            Product_ProductDiscount__c product_productDiscount = new Product_ProductDiscount__c();
            product_productDiscount.Product__c = productId;
            product_productDiscount.ProductDiscount__c = mappedDiscount.Id;
            product_productDiscounts.add(product_productDiscount);
        }
        insert product_productDiscounts;
        System.debug(product_productDiscounts);
        if (!usersEmails.isEmpty()) {
            List<ProductDiscountAssign__c> discountAssigns = new List<ProductDiscountAssign__c>();
            List<User> users = getUsersByEmails(usersEmails);
            for (User user : users) {
                for (Product_ProductDiscount__c product_productDiscount : product_productDiscounts) {
                    ProductDiscountAssign__c productDiscountAssign = new ProductDiscountAssign__c();
                    productDiscountAssign.User__c = user.Id;
                    productDiscountAssign.Product_ProductDiscount__c = product_productDiscount.Id;
                    discountAssigns.add(productDiscountAssign);
                }
            }
            insert discountAssigns;
            System.debug(discountAssigns);
        }
        if (discount.status == 'Active') {
            notifyUsersAboutDiscount(discount, productsIds, usersEmails);
        }
    }

    private static void notifyUsersAboutDiscount(PA_Discount discount, List<String> productsIds, List<String> usersEmails) {
        PA_UserDiscountNotifier notifier = new PA_UserDiscountNotifier(discount, productsIds, usersEmails);
        Database.executeBatch(notifier);
    }

    private static List<User> getUsersByEmails(List<String> emails) {
        return [
                SELECT Id
                FROM User
                WHERE Email IN :emails
        ];
    }

    private static Integer countUserDiscounts() {
        String userId = UserInfo.getUserId();
        AggregateResult result = [
                SELECT count(Id) size
                FROM ProductDiscount__c
                WHERE CreatedById = :userId
        ];
        return (Integer) result.get('size');
    }

    public static void removeDiscount(String discountId) {
        ProductDiscount__c productDiscount = new ProductDiscount__c();
        productDiscount.Id = discountId;
        delete productDiscount;
    }

    public static PA_Discount getDiscountFullData(String discountId) {
        ProductDiscount__c stndDiscount = [
                SELECT Id,
                        Size__c, StartDate__c,
                        EndDate__c
                FROM ProductDiscount__c
                WHERE Id = :discountId
                LIMIT 1
        ];
        PA_Discount discount = new PA_Discount(stndDiscount);
        discount.products = (List<PA_Product>) getProductsByDiscount(discountId, null, null).data;
        discount.usersEmail = getAssignedUserEmails(discountId);
        return discount;
    }
}
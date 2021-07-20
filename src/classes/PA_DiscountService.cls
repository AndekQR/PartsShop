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
                WHERE ((Id IN :product_productDiscountAssigned) OR (Id IN :product_productDiscountNotAssigned)) AND
                Product__c IN :productsIds
        ];
        return PA_Discount.mapToDiscounts(product_productDiscounts);
    }

    public PA_PaginationResponse getDiscountsPage(Integer page, Integer pageSize) {
        String userId = UserInfo.getUserId();
        Integer offset = (page - 1) * pageSize;
        List<String> product_productDiscountNotAssigned = getProductDiscountNotAssignedToUsers();
        List<String> product_productDiscountAssigned = getIdsProductDiscountAssignedToUser(userId);
        List<Product_ProductDiscount__c> product_productDiscounts = [
                SELECT Id, ProductDiscount__r.Id,
                        ProductDiscount__r.Size__c, ProductDiscount__r.StartDate__c,
                        ProductDiscount__r.EndDate__c, Product__c
                FROM Product_ProductDiscount__c
                WHERE ((Id IN :product_productDiscountAssigned) OR (Id IN :product_productDiscountNotAssigned))
                LIMIT :pageSize
                OFFSET :offset
        ];
        Integer allRecordCount = product_productDiscountNotAssigned.size() + product_productDiscountAssigned.size();
        return new PA_PaginationResponse(page, allRecordCount, PA_Discount.mapToDiscounts(product_productDiscounts), pageSize);
    }

    public static PA_PaginationResponse getProductsByDiscount(String discountId, Integer page, Integer pageSize) {
        String userId = UserInfo.getUserId();
        Integer offset = (page - 1) * pageSize;
        List<Product_ProductDiscount__c> product_productDiscounts = [
                SELECT Id, Product__r.Name, Product__r.Quantity__c, Product__r.Rating__c, Product__r.Id,
                        Product__r.Approved__c, Product__r.Price__c, Product__r.Description__c, Product__r.ProductCategory__r.Name
                FROM Product_ProductDiscount__c
                WHERE CreatedById = :userId AND
                ProductDiscount__c = :discountId
                LIMIT :pageSize
                OFFSET :offset
        ];
        List<PA_Product> result =  PA_Product.mapToProducts(product_productDiscounts);
        return new PA_PaginationResponse(page, countProductsByDiscount(discountId), result, pageSize);
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
        List<Product_ProductDiscount__c> result = [
                SELECT Id
                FROM Product_ProductDiscount__c
                WHERE Id NOT IN (SELECT Product_ProductDiscount__c FROM ProductDiscountAssign__c)
        ];
        return getIds(result);
    }

    private List<String> getIdsProductDiscountAssignedToUser(String userId) {
        List<ProductDiscountAssign__c> userDiscountsAssigns = [
                SELECT Id, Product_ProductDiscount__c
                FROM ProductDiscountAssign__c
                WHERE User__c = :userId
        ];
        return getProduct_ProductDiscountIds(userDiscountsAssigns);
    }

    public List<String> getProduct_ProductDiscountIds(List<ProductDiscountAssign__c> objects) {
        List<String> idStrings = new List<String>();
        for (ProductDiscountAssign__c sobj : objects) {
            idStrings.add(sobj.Product_ProductDiscount__c);
        }
        return idStrings;
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
        ProductDiscount__c mappedDiscount = PA_Discount.mapToDiscount(discount);
        insert mappedDiscount;
        List<Product_ProductDiscount__c> product_productDiscounts = new List<Product_ProductDiscount__c>();
        for (String productId : productsIds) {
            Product_ProductDiscount__c product_productDiscount = new Product_ProductDiscount__c();
            product_productDiscount.Product__c = productId;
            product_productDiscount.ProductDiscount__c = mappedDiscount.Id;
            product_productDiscounts.add(product_productDiscount);
        }
        insert product_productDiscounts;
        if(!usersEmails.isEmpty()) {
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
        }
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

    }
}
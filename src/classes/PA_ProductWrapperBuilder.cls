public class PA_ProductWrapperBuilder {

    private List<PA_ProductWrapper> wrappers = new List<PA_ProductWrapper>();

    public PA_ProductWrapperBuilder(List<Product__c> products) {
        this.products(products);
    }

    private void products(List<Product__c> products) {
        for (Product__c product : products) {
            PA_ProductWrapper wrapper = new PA_ProductWrapper();
            wrapper.product = product;
            wrappers.add(wrapper);
        }
    }

    public PA_ProductWrapperBuilder images() {
        List<Attachment> attachments = getImages(getProductsIds());
        for (PA_ProductWrapper wrapper : wrappers) {
            String productId = wrapper.product.Id;
            wrapper.images = getProductImagesData(attachments, productId);
        }
        return this;
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

    private List<String> getProductImagesData(List<Attachment> attachments, String parentId) {
        List<String> result = new List<String>();
        List<Attachment> productAttachments = findAttachments(attachments, parentId);
        for (Attachment attachment : productAttachments) {
            String s = EncodingUtil.base64Encode(attachment.Body);
            result.add(s);
        }
        return result;
    }

    private List<Attachment> findAttachments(List<Attachment> attachments, String parentId) {
        List<Attachment> result = new List<Attachment>();
        for (Attachment attachment : attachments) {
            if (attachment.ParentId == parentId) {
                result.add(attachment);
            }
        }
        return result;
    }

    public PA_ProductWrapperBuilder specifications() {
        List<ProductSpecyfication__c> specs = getProductsSpecyfications(getProductsIds());
        for (PA_ProductWrapper wrapper : wrappers) {
            String productId = wrapper.product.Id;
            wrapper.specyfications = findProductSpecyfications(specs, productId);
        }
        return this;
    }

    private List<ProductSpecyfication__c> findProductSpecyfications(
            List<ProductSpecyfication__c> specs,
            String productId) {
        List<ProductSpecyfication__c> result = new List<ProductSpecyfication__c>();
        for (ProductSpecyfication__c spec : specs) {
            if (spec.Product__c == productId) {
                result.add(spec);
            }
        }
        return result;
    }

    private List<ProductSpecyfication__c> getProductsSpecyfications(List<String> productIds) {
        return [
                SELECT Id, Name, Value__c, Product__c
                FROM ProductSpecyfication__c
                WHERE Product__c IN :productIds
        ];
    }

    public List<PA_ProductWrapper> build() {
        return wrappers;
    }

    private List<String> getProductsIds() {
        List<String> result = new List<String>();
        for (PA_ProductWrapper ob : wrappers) {
            result.add(ob.product.Id);
        }
        return result;
    }

    public PA_ProductWrapperBuilder discount() {
        List<String> productsIds = getProductsIds();
        String userId = UserInfo.getUserId();
        List<ProductDiscount__c> bestDiscounts = [
                SELECT Id, Size__c, EndDate__c, ReservedFor__c, Product__c
                FROM ProductDiscount__c
                WHERE (Product__c IN :productsIds) AND
                (
                        ReservedFor__c = :userId OR ReservedFor__c = null
                )
        ];
        if(!bestDiscounts.isEmpty()) {
            for(PA_ProductWrapper wrapper : wrappers) {
                String productId = wrapper.product.Id;
                wrapper.bestDiscount = findDiscountResult(bestDiscounts, productId);
            }
        }
        return this;
    }

    private ProductDiscount__c findDiscountResult(List<ProductDiscount__c> results, String productId) {
        List<ProductDiscount__c> discounts = new List<ProductDiscount__c>();
        for(ProductDiscount__c result : results) {
            if(result.Product__c == productId) {
                discounts.add(result);
            }
        }
        return findBest(discounts);
    }

    private ProductDiscount__c findBest(List<ProductDiscount__c> discounts) {
        if (!discounts.isEmpty()) {
            ProductDiscount__c best = discounts.get(0);
            for(ProductDiscount__c discount : discounts) {
                if(best.Size__c < discount.Size__c) {
                    best = discount;
                }
            }
            return best;
        }
        return null;
    }
}
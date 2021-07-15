public class PA_ProductWrapperBuilder {

    private List<PA_ProductWrapper> wrappers = new List<PA_ProductWrapper>();
    private PA_Service service { get; set; }

    public PA_ProductWrapperBuilder(List<Product__c> products) {
        this.products(products);
        this.service = new PA_Service();
    }

    private void products(List<Product__c> products) {
        Map<Product__c, Integer> occurrences = this.getOccurrences(products);
        for (Product__c product : occurrences.keySet()) {
            PA_ProductWrapper wrapper = new PA_ProductWrapper();
            wrapper.product = product;
            wrappers.add(wrapper);
        }
    }

    public PA_ProductWrapperBuilder cartQuantity(List<ProductCart__c> productCarts) {
        for(ProductCart__c productCart : productCarts) {
            for(PA_ProductWrapper wrapper : wrappers) {
                if(productCart.Product__c == wrapper.product.Id) {
                    wrapper.cartQuantity = (Integer)productCart.Quantity__c;
                }
            }
        }
        return this;
    }

    private Map<Product__c, Integer> getOccurrences(List<Product__c> products) {
        Map<Product__c, Integer> result = new Map<Product__c, Integer>();
        for (Product__c product : products) {
            if (!result.containsKey(product)) {
                result.put(product, 0);
            }
            Integer currOccurs = result.get(product) + 1;
            result.put(product, currOccurs);
        }
        return result;
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
        List<ProductSpecification__c> specs = getProductsSpecifications(getProductsIds());
        for (PA_ProductWrapper wrapper : wrappers) {
            String productId = wrapper.product.Id;
            wrapper.specifications = findProductSpecifications(specs, productId);
        }
        return this;
    }

    private List<ProductSpecification__c> findProductSpecifications(
            List<ProductSpecification__c> specs,
            String productId) {
        List<ProductSpecification__c> result = new List<ProductSpecification__c>();
        for (ProductSpecification__c spec : specs) {
            if (spec.Product__c == productId) {
                result.add(spec);
            }
        }
        return result;
    }

    private List<ProductSpecification__c> getProductsSpecifications(List<String> productIds) {
        return [
                SELECT Id, Name, Value__c, Product__c
                FROM ProductSpecification__c
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
        List<ProductDiscount__c> allDiscounts = service.getDiscounts(productsIds);
        if (!allDiscounts.isEmpty()) {
            for (PA_ProductWrapper wrapper : wrappers) {
                String productId = wrapper.product.Id;
                wrapper.bestDiscount = service.findBestProductDiscount(allDiscounts, productId);
            }
        }
        return this;
    }

    public PA_ProductWrapperBuilder rateAverage() {
        List<String> productIds = getProductsIds();
        List<ProductReview__c> allReviews = [
                SELECT Id, Rating__c, Product__c
                FROM ProductReview__c
                WHERE Product__c IN :productIds
        ];
        for(PA_ProductWrapper wrapper : wrappers) {
            wrapper.numberOfReviews = getNumberOfReviews(allReviews, wrapper.product.Id);
            wrapper.average = (getRatingSum(allReviews, wrapper.product.Id) / wrapper.numberOfReviews);
        }
        return this;
    }

    private Integer getNumberOfReviews(List<ProductReview__c> allReviews, String productId) {
        Integer result = 0;
        for(ProductReview__c review : allReviews) {
            if(review.Product__c == productId) {
                result++;
            }
        }
        return result;
    }

    private Decimal getRatingSum(List<ProductReview__c> allReviews, String productId){
        Decimal result = 0;
        for(ProductReview__c review : allReviews) {
            if(review.Product__c == productId) {
                result += review.Rating__c;
            }
        }
        return result;
    }

}
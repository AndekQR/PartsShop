public class PA_ProductWrapper {
    @AuraEnabled
    public Product__c product { get; set; }
    @AuraEnabled
    public List<String> images { get; set; }

    public static List<PA_ProductWrapper> createWrappers(
            List<Product__c> products,
            List<Attachment> attachments) {
        List<PA_ProductWrapper> wrappers = new List<PA_ProductWrapper>();
        for (Product__c product : products) {
            PA_ProductWrapper wrapper = new PA_ProductWrapper();
            List<String> imagesData = PA_ProductWrapper.getProductImagesData(attachments, product.Id);
            wrapper.product = product;
            wrapper.images = imagesData;
            wrappers.add(wrapper);
        }
        return wrappers;
    }

    private static List<String> getProductImagesData(List<Attachment> attachments, String parentId) {
        List<String> result = new List<String>();
        List<Attachment> productAttachments = PA_ProductWrapper.findAttachments(attachments, parentId);
        for (Attachment attachment : productAttachments) {
            String s = EncodingUtil.base64Encode(attachment.Body);
            result.add(s);
        }
        return result;
    }

    private static List<Attachment> findAttachments(List<Attachment> attachments, String parentId) {
        List<Attachment> result = new List<Attachment>();
        for (Attachment attachment : attachments) {
            if (attachment.ParentId == parentId) {
                result.add(attachment);
            }
        }
        return result;
    }
}
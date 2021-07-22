public class PA_Review {

    @AuraEnabled
    public String id {get; set;}
    @AuraEnabled
    public String content {get; set;}
    @AuraEnabled
    public Decimal rating {get; set;}
    @AuraEnabled
    public String productId {get; set;}
    @AuraEnabled
    public Datetime createdDate {get; set;}
    @AuraEnabled
    public String createdByName {get; set;}

    public PA_Review(){}

    public PA_Review(ProductReview__c review) {
        this.id = review.Id;
        this.content = review.Content__c;
        this.rating = review.Rating__c;
        this.productId = review.Product__c;
        this.createdDate = review.CreatedDate;
        this.createdByName = review.CreatedBy.Name;
    }

    public static List<PA_Review> mapToReviews(List<ProductReview__c> reviews) {
        List<PA_Review> pa_reviews = new List<PA_Review>();
        for (ProductReview__c productReview : reviews) {
            pa_reviews.add(new PA_Review(productReview));
        }
        return pa_reviews;
    }
}
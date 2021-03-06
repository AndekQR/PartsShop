public class PA_PaginationResponse {
    @AuraEnabled
    public Integer page { get; set; }
    @AuraEnabled
    public List<Object> data { get; set; }
    @AuraEnabled
    public Integer allProductsSize { get; set; }
    @AuraEnabled
    public Integer pageSize { get; set; }

    public PA_PaginationResponse(Integer page, Integer allProductsSize, List<Object> data, Integer pageSize) {
        this.page = page;
        this.allProductsSize = allProductsSize;
        this.data = data;
        this.pageSize = pageSize;
    }
}
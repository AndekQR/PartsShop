({
    init: function(component, event, helper) {
        let product = component.get('v.product');
        if(product.images != null && product.images.length > 0) {
            component.set('v.imageData', product.images[0]);
        }
        helper.setPriceAfterDiscount(component, product.product.Price__c, product.bestDiscount)
    },
    addToCart: function(component, event, helper) {
        event.stopPropagation();
    },
    addToWatchList: function(component, event, helper) {
        helper.addProductToFavorites(component);
        event.stopPropagation();
    },
    productDetails: function(component, event, helper) {
        helper.toProductDetails(component);
    },
})
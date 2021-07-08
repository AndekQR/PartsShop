({
    init: function(component, event, helper) {
        let product = component.get('v.product');
        if(product.ProductImages__r != null && product.ProductImages__r.length > 0) {
            component.set('v.tileImageUrl', product.ProductImages__r[0].Url__c);
        }
    },
    addToCart: function(component, event, helper) {
        console.log('cart');
        event.stopPropagation();
    },
    addToWatchList: function(component, event, helper) {
        helper.addProductToFavorites(component);
        event.stopPropagation();
    },
    productDetails: function(component, event, helper) {
        console.log('details');
    },
})
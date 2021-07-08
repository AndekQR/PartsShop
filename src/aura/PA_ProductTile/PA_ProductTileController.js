({
    init: function(component, event, helper) {
        let product = component.get('v.product');
        if(product.images != null && product.images.length > 0) {
            component.set('v.tileImageUrl', product.images[0]);
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
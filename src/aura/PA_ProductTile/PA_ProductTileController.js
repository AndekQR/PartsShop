({
    init: function(component, event, helper) {
        console.log('productTile init');
        let product = component.get('v.product');
        console.log(JSON.parse(JSON.stringify(product)));
        if(product.images != null && product.images.length > 0) {
            console.log('set image');
            component.set('v.imageData', product.images[0]);
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
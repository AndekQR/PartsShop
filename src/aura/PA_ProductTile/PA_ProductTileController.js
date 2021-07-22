({
    init: function(component, event, helper) {
        let product = component.get('v.product');
        if(product.images != null && product.images.length > 0) {
            component.set('v.imageData', product.images[0]);
        }
        helper.setPriceAfterDiscount(component, product.product.price, product.bestDiscount);
        helper.isWatchList(component);
    },

    addToCart: function(component, event, helper) {
        event.stopPropagation();
        helper.addProductToCart(component);
    },

    addToWatchList: function(component, event, helper) {
        event.stopPropagation();
        helper.addProductToFavorites(component);
    },

    productDetails: function(component, event, helper) {
        helper.toProductDetails(component);
    },

    removeFromWatchList: function(component, event, helper) {
        event.stopPropagation();
        helper.removeFavoriteProduct(component);
    },

    onNotificationChange: function(component, event, helper) {
        event.stopPropagation();
        helper.toggleNotifications(component);
    },
})
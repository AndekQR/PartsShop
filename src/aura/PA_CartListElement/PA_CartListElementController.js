({
    init: function(component, event, helper) {
        let product = component.get('v.productWrapper');
        if(product.images != null && product.images.length > 0) {
            component.set('v.imageData', product.images[0]);
        }
        helper.setPriceAfterDiscount(component, product.product.price, product.bestDiscount)
    },

    addToWatchList: function(component, event, helper) {
        helper.addProductToFavorites(component)
    },

    removeProduct: function(component, event, helper) {
        helper.removeProductFromCart(component);
    },

    onQuantityChange: function(component, event, helper) {
        helper.updateProductQuantity(component);
        helper.fireQuantityChangeEvent(component);
    },
})
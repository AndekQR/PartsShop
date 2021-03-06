({
    init: function(component, event, helper) {
        helper.showSpinner(component);
        let productId = helper.getUrlParameter('productId');
        // let productId = 'a0B090000002GiVEAU';
        helper.getProductDetails(component, productId);
    },

    addToWatchlist: function(component, event, helper) {
        helper.addProductToFavorites(component);
    },

    applyForDiscount: function(component, event, helper) {
        helper.showRequestModal(component);
    },

    addToCart: function(component, event, helper) {
        helper.addProductToCart(component);
    },
})
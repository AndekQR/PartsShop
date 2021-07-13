({
    init: function(component, event, helper) {
        helper.showSpinner(component);
        let productId = helper.getUrlParameter('productId');
        // let productId = 'a0B090000002GiVEAU';
        helper.getProductDetails(component, productId);
    },

})
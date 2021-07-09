({
    init: function(component, event, helper) {
        let productId = helper.getUrlParameter('c__productId');
        helper.getProductDetails(component, productId);
    },
})
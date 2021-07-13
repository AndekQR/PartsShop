({
    toProductDetails: function(component, event, helper) {
        let params = event.getParam('arguments');
        const productId = params.productId;
        const url = '/product-detail';
        helper.navigate(url+'?productId='+productId);
    },
    toCart: function(component, event, helper) {
        const url = '/cart';
        helper.navigate(url+'?listDataType=cart');
    }
})
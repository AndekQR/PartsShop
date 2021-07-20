({
    onDiscountIdChange: function(component, event, helper) {
        console.log('onDiscountIdChange');
        let discountId = event.getParam('id');
        let productListComponent = component.find('productListComp');
        console.log(discountId);
        productListComponent.changeDiscountId(discountId);
    },
})
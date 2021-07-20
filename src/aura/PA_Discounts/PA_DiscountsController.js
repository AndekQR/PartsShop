({
    onDiscountIdChange: function(component, event, helper) {
        let discountId = event.getParam('id');
        let productListComponent = component.find('productListComp');
        productListComponent.changeDiscountId(discountId);
    },

    onDiscountAdd: function(component, event, helper) {
        let discountsList = component.find('discountsList');
        discountsList.refresh();
    },
})
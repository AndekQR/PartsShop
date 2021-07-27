({
    onDiscountIdChange: function(component, event, helper) {
        let discountId = event.getParam('id');
        let discountSize = event.getParam('discountSize');
        console.log(discountSize);
        let productListComponent = component.find('productListComp');
        productListComponent.changeDiscountId(discountId, discountSize);
    },

    onDiscountAdd: function(component, event, helper) {
        let discountsList = component.find('discountsList');
        for (const list of discountsList) {
            list.refresh();
        }
    },

    onFormFill: function(component, event, helper) {
        let discountId = event.getParam('discountId');
        let list = component.find('discountForm');
        list.fillForm(discountId);
    },
})
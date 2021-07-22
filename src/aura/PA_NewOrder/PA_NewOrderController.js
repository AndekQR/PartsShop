({
    init: function (component, event, helper) {
        helper.setAllUserAddresses(component);
        helper.setAllCartProducts(component);
    },

    onNewAddress: function (component, event, helper) {
        helper.showNewAddressFlow(component);
    },

    handleFlowStatusChange: function(component, event, helper) {
        if(event.getParam("status") === "FINISHED") {
            let outputVariables = event.getParam("outputVariables");
            helper.setAllUserAddresses(component);
            component.set('v.choosedAddressId', outputVariables[0].value.Id);
        }
    },

    onCancel: function (component, event, helper) {
        helper.closeModal(component);
    },

    onNewOrder: function (component, event, helper) {
        helper.convertCartToOrder(component);
    },

    onAddressChoose: function (component, event, helper) {
        let addressId = event.currentTarget.dataset.id;
        component.set('v.choosedAddressId', addressId);
    },

    onAddressRemove: function(component, event, helper) {
        event.stopPropagation();
        let addressId = event.currentTarget.dataset.id;
        helper.removeAddress(component, addressId);
    },
})
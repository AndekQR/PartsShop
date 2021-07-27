({
    onAddDiscount: function(component, event, helper) {
        helper.addDiscount(component);
    },

    onCancel: function(component, event, helper) {
        helper.closeModal(component);
    },
})
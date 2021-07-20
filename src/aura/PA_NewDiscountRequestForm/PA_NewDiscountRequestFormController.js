({
    init: function(component, event, helper) {
        helper.clearForm(component);
    },

    onRequestSend: function(component, event, helper) {
        helper.addDiscount(component);
    },

    onCancel: function(component, event, helper) {
        helper.clearForm(component);
        helper.closeModal(component);
    },
})
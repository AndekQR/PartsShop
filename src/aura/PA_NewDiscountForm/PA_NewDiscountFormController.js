({
    init: function(component, event, helper) {
        helper.setUserProducts(component);
        helper.clearForm(component);
    },

    onNewRecord: function(component, event, helper) {
        helper.clearForm(component);
    },

    showSummaryModal: function(component, event, helper) {
        helper.showDiscountSummaryModal(component);
    },

    onClear: function(component, event, helper) {
        helper.clearForm(component);
    },

    onEmailAdd: function(component, event, helper) {
        helper.addToEmailList(component);
    },

    fillForm: function(component, event, helper) {
        helper.setFormData(component, event);
    },
})
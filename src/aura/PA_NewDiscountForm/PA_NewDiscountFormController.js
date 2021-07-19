({
    init: function(component, event, helper) {
        helper.setUserProducts(component);
        helper.clearForm(component);
    },

    onAddDiscount: function(component, event, helper) {
        helper.addDiscount(component);
    },

    onClear: function(component, event, helper) {
        helper.clearForm(component);
    },

    onEmailAdd: function(component, event, helper) {
        helper.addToEmailList(component);
    },

})
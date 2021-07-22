({
    nextPage: function (component, event, helper) {
        helper.setNextPage(component);
    },

    previousPage: function (component, event, helper) {
        helper.setPreviousPage(component);
    },

    firstPage: function (component, event, helper) {
        helper.setFirstPage(component);
    },

    lastPage: function (component, event, helper) {
        helper.setLastPage(component);
    },

    onDiscountIdChange: function(component, event, helper) {
        let params = event.getParam('arguments');
        let discountId = params.id;
        component.set('v.discountId', discountId);
        helper.setFirstPage(component);
    },
})
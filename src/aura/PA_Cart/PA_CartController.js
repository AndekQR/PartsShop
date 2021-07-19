({
    init: function (component, event, helper) {
        helper.setFirstPage(component);
        helper.setCartPriceSum(component);
    },
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

    onProductRemovedFromCart: function(component, event, helper) {
        helper.setFirstPage(component);
        helper.setCartPriceSum(component);
    },

    onQuantityChange: function(component, event, helper) {
        helper.setCartPriceSum(component);
    },

    onMakeOrder: function(component, event, helper) {

    },
})
({
    init: function (component, event, helper) {
        helper.setFirstPage(component);
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

    onRowSelect: function(component, event, helper) {
        let selectedRowId = event.currentTarget.dataset.myid;
        component.set("v.selectedRowId", selectedRowId);
        helper.fireRowSelectedEvent(component, selectedRowId);
    },

    onDiscountDelete: function(component, event, helper) {
        event.stopPropagation();
        helper.removeDiscount(component, event);
    },
})
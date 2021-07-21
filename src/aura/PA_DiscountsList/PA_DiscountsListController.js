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
        let isRequests = component.get('v.requests');
        let selectedRowId = event.currentTarget.dataset.myid;
        component.set("v.selectedRowId", selectedRowId);
        if(isRequests) {
            helper.fillUpDiscountFormEvent(component, selectedRowId);
        } else {
            helper.fireRowSelectedEvent(component, selectedRowId);
        }
    },

    onDiscountDelete: function(component, event, helper) {
        event.stopPropagation();
        helper.removeDiscount(component, event);
    },
})
({
    init: function (component, event, helper) {
        helper.setFirstPage(component);
        helper.refreshData(component);
    },

    change: function (component, event, helper) {
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
    }
})
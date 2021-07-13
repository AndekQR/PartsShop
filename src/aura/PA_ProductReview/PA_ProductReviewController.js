({
    init: function (component, event, helper) {
        helper.setFirstPage(component);
    },

    change: function (component, event, helper) {
        helper.setFirstPage(component);
    },

    onSave: function (component, event, helper) {
        helper.saveReview(component);
    },

    setReviews: function (component, event, helper) {
        helper.setReviews(component);
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
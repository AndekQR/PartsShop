({
    init: function(component, event, helper) {
        helper.setAllCategories(component);
    },

    onCategoryClick: function(component, event, helper) {
        helper.fireCategoryChangeEvent(component, event);
    },
})
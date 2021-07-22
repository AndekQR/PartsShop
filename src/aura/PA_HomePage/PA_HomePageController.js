({
    onCategoryChange: function(component, event, helper) {
        let categoryId = event.getParam('categoryId');
        component.set('v.categoryId', categoryId);
        if(categoryId == null) {
            component.set('v.listType', 'latest');
        } else {
            component.set('v.listType', 'categories');
        }
        helper.refreshProductList(component);
    },
})
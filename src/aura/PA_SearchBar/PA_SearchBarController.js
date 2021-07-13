({
    searchField: function (component, event, helper) {
        const searchQuery = event.getSource().get('v.value');
        helper.searchRecords(component, searchQuery);
    },

    onKeyPress: function (component, event, helper) {
        const pressedKeyName = event.key;
        switch (pressedKeyName) {
            case 'Enter': {
                helper.fireShowSearchListEvent(component);
            }/* falls through */
            case 'Escape': {
                helper.removeResultBox(component);
                helper.clearSelected(component);
                break;
            }
        }
    },

    resetData: function (component, event, helper) {
        helper.clearSelected(component);
        helper.removeResultBox(component);
    },

    setSelectedRecord: function (component, event, helper) {
        let productId = event.currentTarget.id;
        let productName = event.currentTarget.dataset.name;
        helper.removeResultBox(component);
        component.set('v.selectRecordName', productName);
        component.set('v.selectRecordId', productId);
        helper.toProduct(component);
        helper.clearSelected(component);
    }
})
({
    searchField: function(component, event, helper) {

    },

    onKeyPress: function (component, event, helper) {
        let pressedKeyName = event.key;
        switch (pressedKeyName) {
            case 'Enter': {

                break;
            }
            case 'Escape': {

                break;
            }
        }
    },

    resetData: function (component, event, helper) {
        helper.clearSelected(component);
        helper.removeResultBox(component);
    },
})
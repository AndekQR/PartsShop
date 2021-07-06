({
    turnOnSpinner: function(component, event, helper) {
        component.set('v.state', true);
    },

    turnOffSpinner: function(component, event, helper) {
        component.set('v.state', false);
    }
})
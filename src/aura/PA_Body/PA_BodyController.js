({
    onChangeBodyContent: function(component, event, helper) {
        let contentType = event.getParam('whatToShow');
        component.set('v.whatToShow', contentType);
        helper.hideSpinner(component);
    },
})
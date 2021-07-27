({
    showSuccessToast: function(component, event, helper) {
        let params = event.getParam('arguments');
        let message = params.message;
        helper.showToast(message);
    },
    showWarningToast: function(component, event, helper) {
        let params = event.getParam('arguments');
        let message = params.message;
        helper.showToast(message);
    },
    handleActionError: function(component, event, helper) {
        let params = event.getParam('arguments');
        let actionResponse = params.response;
        helper.handleError(actionResponse);
        helper.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
    },
})
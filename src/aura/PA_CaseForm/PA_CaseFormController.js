({
    init: function(component, event, helper) {
        let order = component.get('v.orderObject');
        if(order.caseId != null) {
            helper.getCaseData(component);
        } else {
            component.set('v.case', {});
        }
    },

    onNewReclamation: function(component, event, helper) {
        helper.saveReclamation(component);
    },

    onClose: function(component, event, helper) {
        helper.closeModal(component);
    },
})
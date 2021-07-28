({
    getCaseData: function(component) {
        let order = component.get('v.orderObject');
        let action = component.get('c.getCase');
        action.setParams({
            caseId: order.caseId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.case', returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    saveReclamation: function(component) {
        let order = component.get('v.orderObject');
        let caseToSave = component.get('v.case');
        caseToSave.orderId = order.id;
        caseToSave.relatedProducts = order.products;
        let action = component.get('c.saveCase');
        action.setParams({
            caseToSave: caseToSave
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.reclamation_sent'));
                this.closeModal(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})
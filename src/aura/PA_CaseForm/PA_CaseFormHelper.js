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
                this.handleError(response);
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
                this.showToast('Success', $A.get('$Label.c.reclamation_sent'), 'success');
                this.closeModal(component);
            } else {
                this.handleError(response);
                this.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (title, message, type) {
        let resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        resultsToast.fire();
    },

    handleError: function (response) {
        let errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.error("Error message: " +
                    errors[0].message);
            }
        } else {
            console.error("Unknown error");
        }
    },

    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    },
})
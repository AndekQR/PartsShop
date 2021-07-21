({
    addDiscount: function (component) {
        if(!this.isFormValid(component, 'requestForm')) {
            return;
        }
        let discount = component.get('v.discount');
        let productId = component.get('v.discountProductId');
        let userEmail = $A.get("$SObjectType.CurrentUser.Email");
        let action = component.get('c.addDiscount');
        action.setParams({
            discount: discount,
            productsIds: [productId],
            usersEmails: [userEmail]
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.showToast('Success', $A.get('$Label.c.request_sent'), 'success');
                this.clearForm(component);
                this.closeModal(component);
            } else {
                this.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
            }
        });
        $A.enqueueAction(action);
    },

    clearForm: function (component) {
        let discount = {
            size: 5,
            status: 'Request'
        };
        component.set('v.discount', discount);
    },

    isFormValid: function (component, formId) {
        return component.find(formId).reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
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

    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    }
})
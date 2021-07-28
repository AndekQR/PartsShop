({
    addDiscount: function (component) {
        if(!this.isFormValid(component, 'requestForm')) {
            return;
        }
        let discount = component.get('v.discount');
        let productId = component.get('v.product').id;
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
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.request_sent'));
                this.clearForm(component);
                this.closeModal(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
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


    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})
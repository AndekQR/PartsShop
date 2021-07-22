({
    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    },

    fireNewRecordEvent: function () {
        let event = $A.get('e.c:PA_NewRecordEvent');
        event.fire();
    },

    addDiscount: function (component) {
        let discount = component.get('v.discount');
        let discountProducts = component.get('v.discountProducts').map(element => element.id);
        let emails = component.get('v.usersEmails');
        let action = component.get('c.addDiscount');
        action.setParams({
            discount: discount,
            productsIds: discountProducts,
            usersEmails: emails
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.fireNewRecordEvent();
                this.closeModal(component);
            } else {
                this.handleError(response);
                this.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
            }
        });
        $A.enqueueAction(action);
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

    showToast: function (title, message, type) {
        let resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        resultsToast.fire();
    },
})
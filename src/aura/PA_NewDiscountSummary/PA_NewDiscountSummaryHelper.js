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
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})
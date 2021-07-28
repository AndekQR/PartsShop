({
    insertAddress: function (component) {
        let address = component.get('v.choosedAddress');
        let action = component.get('c.createAddress');
        action.setParams({
            createAddress: address
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.setAllUserAddresses(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setAllUserAddresses: function (component) {
        let action = component.get('c.getCartAllAddresses');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.allAddresses', returnValue);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    convertCartToOrder: function (component) {
        let addressId = component.get('v.choosedAddressId');
        let action = component.get('c.makeOrder');
        action.setParams({
            addressId: addressId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.fireNewOrderEvent();
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.new_order_created'));
                this.closeModal(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    showNewAddressFlow: function (component) {
        let flow = component.find("flowData");
        flow.startFlow("New_Order_Address_Flow");
    },

    setAllCartProducts: function (component) {
        let action = component.get('c.getAllProductsCart');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.wrappers', returnValue);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    },

    removeAddress: function (component, addressId) {
        let choosedAddressId = component.get('v.choosedAddressId');
        if (choosedAddressId === addressId) {
            component.set('v.choosedAddressId', null);
        }
        let action = component.get('c.removeAddress');
        action.setParams({
            addressId: addressId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.address_record_deleted'));
                this.setAllUserAddresses(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    fireNewOrderEvent: function () {
        let event = $A.get('e.c:PA_NewOrderEvent');
        event.fire();
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})
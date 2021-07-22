({
    insertAddress: function(component) {
        let address = component.get('v.choosedAddress');
        let action = component.get('c.createAddress');
        action.setParams({
            createAddress: address
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.setAllUserAddresses(component);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setAllUserAddresses: function(component) {
        let action = component.get('c.getCartAllAddresses');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.allAddresses', returnValue);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    convertCartToOrder: function(component) {
        let addressId = component.get('v.choosedAddressId');
        let action = component.get('c.convertToOrder');
        action.setParams({
            addressId: addressId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.showToast('Success', $A.get('$Label.c.new_order_created'), 'success');
                this.closeModal(component);
            } else {
                this.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
                this.handleError(response);
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

    showNewAddressFlow: function(component) {
        let flow = component.find("flowData");
        flow.startFlow("New_Order_Address_Flow");
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

    setAllCartProducts: function(component) {
        let action = component.get('c.getAllProductsCart');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.wrappers', returnValue);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    closeModal: function (component) {
        component.find('overlayLib').notifyClose();
    },

    removeAddress: function(component, addressId) {
        let choosedAddressId = component.get('v.choosedAddressId');
        if(choosedAddressId === addressId) {
            component.set('v.choosedAddressId', null);
        }
        let action = component.get('c.removeAddress');
        action.setParams({
            addressId: addressId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.showToast('Success', 'Address record deleted', 'success')
                this.setAllUserAddresses(component);
            } else {
                this.showToast('Error', $A.get('$Label.c.something_went_wrong'), 'error');
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    }
})
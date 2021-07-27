({
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

    setCartPriceSum: function(component) {
        let action = component.get('c.getUserCart');
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.priceSum', returnValue.priceSum);
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
({
    getUrlParameter: function (sParam) {
        let sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'), sParameterName, i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },

    getProductDetails: function (component, productId) {
        let action = component.get('c.getProductDetails');
        action.setParams({
            productId: productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.product', returnValue);
                let originalPrice = returnValue.product.price;
                let bestDiscount = returnValue.bestDiscount;
                this.setPriceAfterDiscount(component, originalPrice, bestDiscount);
                this.hideSpinner(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setPriceAfterDiscount: function(component, originalPrice, bestDiscount) {
        if(bestDiscount == null) {
            component.set('v.priceAfterDiscount', originalPrice);
        } else {
            let percent = bestDiscount.size / 100;
            let afterDiscount = originalPrice - (originalPrice * percent);
            afterDiscount = Math.round(afterDiscount * 100) / 100;
            component.set('v.priceAfterDiscount', afterDiscount);
        }
    },

    showSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOn();
    },
    hideSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOff();
    },

    addProductToCart: function (component) {
        let quantity = component.get('v.quantity');
        const productId = component.get('v.product').product.id;
        let action = component.get('c.addToUserCart');
        action.setParams({
            productId: productId,
            quantity: quantity
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.getNotificationHandler(component).showSuccessToast('Product went to your cart!');
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    addProductToFavorites: function (component) {
        let product = component.get('v.product').product;
        let action = component.get('c.addToFavorites');
        action.setParams({
            productId: product.id
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.getNotificationHandler(component).showSuccessToast('Product went to your favorites!');
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    showRequestModal: function (component) {
        let product = component.get('v.product').product;
        $A.createComponent('c:PA_NewDiscountRequestForm', {
            'product': product
        }, (resultBody, status, errorMessage) => {
            if (status === 'SUCCESS') {
                component.find('overlayLib').showCustomModal({
                    body: resultBody,
                    showCloseButton: true,
                    cssClass: ''
                });
            } else {
                console.log("Error: " + errorMessage);
            }
        });
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})
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
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    handleError: function (response) {
        let errors = response.getError();
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.log("Error message: " +
                    errors[0].message);
            }
        } else {
            console.log("Unknown error");
        }
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
        const productId = component.get('v.product').product.id;
        let action = component.get('c.addToUserCart');
        action.setParams({
            productId: productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.showToast('Success', 'Product went to your cart!', 'success');
            } else {
                this.handleError(response);
                this.showToast('Error', 'Something went wrong. Try again!', 'error');
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

    addProductToFavorites: function (component) {
        let product = component.get('v.product').product;
        let action = component.get('c.addToFavorites');
        action.setParams({
            productId: product.id
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.showToast('Success', 'Product went to your favorites!', 'success');
            } else {
                this.handleError(response);
                this.showToast('Warning', response.getError()[0].message, 'warning');
            }
        });
        $A.enqueueAction(action);
    },
})
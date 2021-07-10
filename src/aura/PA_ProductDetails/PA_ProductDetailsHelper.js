({
    getUrlParameter: function (sParam) {
        let sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        console.log('params');
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
            console.log(sParameterName);
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
                console.log(JSON.parse(JSON.stringify(returnValue)));
                let originalPrice = returnValue.product.Price__c;
                let bestDiscount = returnValue.bestDiscount;
                this.setPriceAfterDiscount(component, originalPrice, bestDiscount);
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
            let percent = bestDiscount.Size__c / 100;
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
})
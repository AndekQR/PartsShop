({
    addProductToFavorites: function(component) {
        let product = component.get('v.product');
        let action = component.get('c.addToFavorites');
        action.setParams({
            productId: product.Id
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.showToast('Success', 'Product went to your favorites!', 'success');
            } else {
                this.handleError(response);
                this.showToast('Error', 'Something went wrong. Try again.', 'error');
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

    toProductDetails: function(component) {
        let productId = component.get('v.product').product.Id;
        let navComponent = component.find('navigation');
        navComponent.navigate('/product-detail', productId);
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
})
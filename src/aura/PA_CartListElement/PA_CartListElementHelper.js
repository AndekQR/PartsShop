({
    setPriceAfterDiscount: function (component, originalPrice, bestDiscount) {
        if (bestDiscount == null) {
            component.set('v.priceAfterDiscount', originalPrice);
        } else {
            let percent = bestDiscount.Size__c / 100;
            let afterDiscount = originalPrice - (originalPrice * percent);
            afterDiscount = Math.round(afterDiscount * 100) / 100;
            component.set('v.priceAfterDiscount', afterDiscount);
        }
    },

    addProductToFavorites: function (component) {
        // let product = component.get('v.product');
        // let action = component.get('c.addToFavorites');
        // action.setParams({
        //     productId: product.Id
        // });
        // action.setCallback(this, (response) => {
        //     let state = response.getState();
        //     if (state === 'SUCCESS') {
        //         this.showToast('Success', 'Product went to your favorites!', 'success');
        //     } else {
        //         this.handleError(response);
        //         this.showToast('Error', 'Something went wrong. Try again.', 'error');
        //     }
        // });
        // $A.enqueueAction(action);
    },

    removeProductFromCart: function (component) {
        console.log('remove from cart');
        const productId = component.get('v.productWrapper').product.Id;
        let action = component.get('c.removeFromCart');
        action.setParams({
            productId: productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.fireRemoveFromCartEvent(component);
                this.showToast('Success', 'Product removed from cart!', 'success');
            } else {
                this.handleError(response);
                this.showToast('Error', 'Something went wrong. Try again.', 'error');
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

    showToast: function (title, message, type) {
        let resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        resultsToast.fire();
    },

    fireRemoveFromCartEvent: function (component) {
        let event = component.getEvent('PA_ProductRemovedFromCart');
        event.fire();
    },

    fireQuantityChangeEvent: function (component) {
        let event = component.getEvent('PA_OnProductQuantityChange');
        event.fire();
    },

    updateProductQuantity: function (component) {
        let productWrapper = component.get('v.productWrapper');
        if(productWrapper != null) {
            let action = component.get('c.updateProductCartQuantity');
            action.setParams({
                productId: productWrapper.product.Id,
                quantity: productWrapper.cartQuantity
            });
            $A.enqueueAction(action);
        }
    }
})
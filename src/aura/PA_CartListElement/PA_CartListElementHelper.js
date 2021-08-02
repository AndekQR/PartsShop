({
    setPriceAfterDiscount: function (component, originalPrice, bestDiscount) {
        if (bestDiscount == null) {
            component.set('v.priceAfterDiscount', originalPrice);
        } else {
            let percent = bestDiscount.size / 100;
            let afterDiscount = originalPrice - (originalPrice * percent);
            afterDiscount = Math.round(afterDiscount * 100) / 100;
            component.set('v.priceAfterDiscount', afterDiscount);
        }
    },

    addProductToFavorites: function (component) {
        let product = component.get('v.productWrapper').product;
        let action = component.get('c.addToFavorites');
        action.setParams({
            productId: product.id
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.product_went_favorites'));
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    removeProductFromCart: function (component) {
        const productId = component.get('v.productWrapper').product.id;
        let action = component.get('c.removeFromCart');
        action.setParams({
            productId: productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.fireRemoveFromCartEvent(component);
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.product_removed_cart'));
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
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
        if (productWrapper != null) {
            let quantityToSet;
            if (isNaN(productWrapper.cartQuantity) || Number(productWrapper.cartQuantity) < 1) {
                quantityToSet = 1;
            } else {
                if (productWrapper.cartQuantity > productWrapper.product.quantity) {
                    quantityToSet = productWrapper.product.quantity;
                    console.log('too high');
                } else {
                    quantityToSet = productWrapper.cartQuantity;
                }
            }
            component.set('v.productWrapper.cartQuantity', quantityToSet);
            let action = component.get('c.updateProductCartQuantity');
            action.setParams({
                productId: productWrapper.product.id,
                quantity: quantityToSet
            });
            action.setCallback(this, (response) => {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    this.fireQuantityChangeEvent(component);

                } else {
                    this.getNotificationHandler(component).handleActionError(response);
                }
            });
            $A.enqueueAction(action);
        }
    },

    getNotificationHandler: function (component) {
        return component.find('notificationHandler');
    }
})
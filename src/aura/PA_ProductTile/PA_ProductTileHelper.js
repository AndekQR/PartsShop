({
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
                console.error("Error message: " +
                    errors[0].message);
            }
        } else {
            console.error("Unknown error");
        }
    },

    toProductDetails: function (component) {
        let productId = component.get('v.product').product.id;
        let navComponent = component.find('navigation');
        navComponent.navigateToProductDetails(productId);
    },

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

    addProductToCart: function (component) {
        const productId = component.get('v.product').product.id;
        let action = component.get('c.addToUserCart');
        action.setParams({
            productId: productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                this.showToast('Success', 'Product went to your cart!', 'success');
            } else {
                this.handleError(response);
                this.showToast('Error', 'Something went wrong. Try again!', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    isWatchList: function (component) {
        let path = window.location.pathname;
        if (path === '/s/watch-list') {
            component.set('v.isWatchList', true);
        }
    },

    removeFavoriteProduct: function(component) {
        const productId = component.get('v.product').product.id;
        let action = component.get('c.removeFromFavorites');
        action.setParams({
            productId: productId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                // labelk
                this.showToast('Success', 'Product removed from your cart!', 'success');
                this.callRefreshData(component);
            } else {
                this.handleError(response);
                this.showToast('Error', 'Something went wrong. Try again!', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    callRefreshData: function(component) {
        let method = component.get('v.refreshDataMethod');
        $A.enqueueAction(method);
    }
})
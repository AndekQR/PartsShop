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
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.product_went_favorites'));
            } else {
                this.getNotificationHandler(component).showWarningToast(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
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
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.product_went_cart'));
            } else {
                this.getNotificationHandler(component).handleActionError(response);
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
                this.getNotificationHandler(component).showSuccessToast($A.get('$Label.c.product_removed_cart'));
                this.callRefreshData(component);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    callRefreshData: function(component) {
        let method = component.get('v.refreshDataMethod');
        $A.enqueueAction(method);
    },
    
    toggleNotifications: function(component) {
        let wrapper = component.get('v.product');
        let action = component.get('c.toggleNotifications');
        action.setParams({
            productId: wrapper.product.id
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                
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
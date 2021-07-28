({
    searchRecords: function (component, query) {
        if (query === null || query === '') {
            return;
        }
        component.set('v.selectRecordName', query);
        component.set('v.LoadingText', true);
        if (query.length > 0) {
            this.showResultBox(component);
        } else {
            this.removeResultBox(component);
        }
        let action = component.get('c.searchProducts');
        action.setParams({
            searchQuery: query,
            page: 1
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                component.set('v.searchRecords', returnValue.data);
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
            component.set('v.LoadingText', false);
        });
        $A.enqueueAction(action);
    },

    removeResultBox: function (component) {
        let resultBox = component.find('resultBox');
        $A.util.removeClass(resultBox, 'slds-is-open');
    },

    showResultBox: function (component) {
        let resultBox = component.find('resultBox');
        $A.util.addClass(resultBox, 'slds-is-open');
    },

    clearSelected: function (component) {
        component.set('v.selectRecordName', '');
        component.set('v.selectRecordId', '');
    },

    toProduct: function(component) {
        let productId = component.get('v.selectRecordId');
        let navComponent = component.find('navigation');
        navComponent.navigateToProductDetails(productId);
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})


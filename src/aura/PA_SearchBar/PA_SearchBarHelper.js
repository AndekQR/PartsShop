({
    searchRecords: function (component, query) {
        if (query == null || query == '') {
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
                component.set('v.searchRecords', returnValue);
            } else {
                this.handleError(response);
            }
            component.set('v.LoadingText', false);
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

    fireProductSelectedEvent: function (component, productId) {
        let event = $A.get('e.c:PA_ProductSelectedEvent');
        event.setParams({
            productId: productId
        });
        event.fire();
    },

    fireShowSearchListEvent: function (component) {
        let query = component.get('v.selectRecordName');
        let event = $A.get('e.c:PA_ShowSearchListEvent');
        event.setParams({
            query: query
        });
        event.fire();
    }
})
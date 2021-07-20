({
    refreshData: function(component) {
        let isRequests = component.get('v.requests');
        switch (isRequests) {
            case true: {
                this.refreshRequestsData(component);
                break;
            }
            case false: {
                this.refreshDiscountData(component);
                break;
            }
        }
    },

    refreshRequestsData: function(component) {
        let page = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let action = component.get('c.getRequestedDiscounts');
        action.setParams({
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    refreshDiscountData: function(component) {
        let page = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let action = component.get('c.getDiscountsPage');
        action.setParams({
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue);
            } else {
                this.handleError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setAllPageSize: function (component) {
        let pageSize = component.get('v.pageSize');
        let allObjectsSize = component.get('v.allProductsSize');
        let number = (Math.ceil(allObjectsSize / pageSize));
        if (number < 1) {
            component.set('v.allPageSize', 1);
        } else {
            component.set('v.allPageSize', number);
        }
    },

    setFirstPage: function (component) {
        component.set('v.pageNumber', 1);
        this.refreshData(component);
    },

    setLastPage: function (component) {
        let allPageSize = component.get('v.allPageSize');
        component.set('v.pageNumber', allPageSize);
        this.refreshData(component);
    },

    setNextPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        let allPageSize = component.get('v.allPageSize');
        if (pageNumber < allPageSize) {
            component.set('v.pageNumber', (pageNumber + 1));
            this.refreshData(component);
        }
    },

    setPreviousPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        if (pageNumber > 1) {
            component.set('v.pageNumber', (pageNumber - 1));
            this.refreshData(component);
        }
    },

    setPaginationData: function (component, returnValue) {
        component.set('v.data', returnValue.data);
        component.set('v.pageNumber', returnValue.page);
        component.set('v.pageSize', returnValue.pageSize);
        component.set('v.allProductsSize', returnValue.allProductsSize);
        this.setAllPageSize(component);
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

    fireRowSelectedEvent: function(component, discountId) {
        let event = component.getEvent('PA_DiscountIdChangeEvent');
        event.setParams({
            id: discountId,
        });
        event.fire();
    },

    removeDiscount: function(component, event) {
        let discountId = event.currentTarget.dataset.myid;
        let action = component.get('c.removeDiscount');
        action.setParams({
            discountId: discountId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                this.showToast('Success', 'Discount deleted', 'success');
                this.refreshData(component);
            } else {
                this.showToast('Error',  $A.get('$Label.c.something_went_wrong'), 'error');
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

    fillUpDiscountFormEvent: function (component) {

    }
})
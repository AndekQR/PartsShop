({
    refreshDiscountData: function(component) {
        console.log('refresh discount size');
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
                console.log(JSON.parse(JSON.stringify(returnValue)));
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
        this.refreshDiscountData(component);
    },

    setLastPage: function (component) {
        let allPageSize = component.get('v.allPageSize');
        component.set('v.pageNumber', allPageSize);
        this.refreshDiscountData(component);
    },

    setNextPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        let allPageSize = component.get('v.allPageSize');
        if (pageNumber < allPageSize) {
            component.set('v.pageNumber', (pageNumber + 1));
            this.refreshDiscountData(component);
        }
    },

    setPreviousPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        if (pageNumber > 1) {
            component.set('v.pageNumber', (pageNumber - 1));
            this.refreshDiscountData(component);
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

    }
})
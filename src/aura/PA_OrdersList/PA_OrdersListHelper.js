({
    setUsersOrders: function(component) {
        let page = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let action = component.get('c.getUsersOrders');
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
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setPaginationData: function (component, returnValue) {
        component.set('v.orders', returnValue.data);
        component.set('v.pageNumber', returnValue.page);
        component.set('v.pageSize', returnValue.pageSize);
        component.set('v.allOrdersSize', returnValue.allProductsSize);
        this.setAllPageSize(component);
    },

    setAllPageSize: function (component) {
        let pageSize = component.get('v.pageSize');
        let allObjectsSize = component.get('v.allOrdersSize');
        let number = (Math.ceil(allObjectsSize / pageSize));
        if (number < 1 || number == null) {
            component.set('v.allPageSize', 1);
        } else {
            component.set('v.allPageSize', number);
        }
    },

    setFirstPage: function (component) {
        component.set('v.pageNumber', 1);
        this.setUsersOrders(component);
    },

    setLastPage: function (component) {
        let allPageSize = component.get('v.allPageSize');
        component.set('v.pageNumber', allPageSize);
        this.setUsersOrders(component);
    },

    setNextPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        let allPageSize = component.get('v.allPageSize');
        if (pageNumber < allPageSize) {
            component.set('v.pageNumber', (pageNumber + 1));
            this.setUsersOrders(component);
        }
    },

    setPreviousPage: function (component) {
        let pageNumber = component.get('v.pageNumber');
        if (pageNumber > 1) {
            component.set('v.pageNumber', (pageNumber - 1));
            this.setUsersOrders(component);
        }
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})
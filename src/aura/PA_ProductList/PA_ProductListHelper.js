({
    refreshData: function (component) {
        this.showSpinner(component);
        let whatToSow = component.get('v.whatToShow');
        switch (whatToSow) {
            case 'watchList': {
                this.setFavorites(component);
                break;
            }
            case 'userProducts': {
                this.setUserProducts(component);
                break;
            }
            case 'categories': {
                this.setProductsByCategory(component);
                break;
            }
            default: {
                this.setLatest(component);
            }
        }
    },

    showSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOn();
    },
    hideSpinner: function (component) {
        let spinnerComponent = component.find('spinner');
        spinnerComponent.turnOff();
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

    getUrlParameter: function (sParam) {
        let sPageURL = decodeURIComponent(window.location.search.substring(1));
        let sURLVariables = sPageURL.split('&');
        let sParameterName;

        for (let i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },

    setObjectByQuery: function (component, query) {
        let page = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let action = component.get('c.searchProducts');
        action.setParams({
            searchQuery: query,
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setFullObjectList: function (component) {
        let page = component.get('v.pageNumber');
        let action = component.get('c.searchProducts');
        let pageSize = component.get('v.pageSize');
        action.setParams({
            searchQuery: null,
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setUserProducts: function(component) {
        let page = component.get('v.pageNumber');
        let action = component.get('c.userProducts');
        let pageSize = component.get('v.pageSize');
        action.setParams({
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },
    setProductsByCategory: function(component) {
        let categoryId = component.get('v.categoryId');
        let page = component.get('v.pageNumber');
        let action = component.get('c.getProductsByCategory');
        let pageSize = component.get('v.pageSize');
        action.setParams({
            page: page,
            pageSize: pageSize,
            categoryId: categoryId
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setLatest: function (component) {
        let page = component.get('v.pageNumber');
        let action = component.get('c.latestProducts');
        let pageSize = component.get('v.pageSize');
        action.setParams({
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },
    
    setFavorites: function (component) {
        let page = component.get('v.pageNumber');
        let pageSize = component.get('v.pageSize');
        let action = component.get('c.getFavorites');
        action.setParams({
            page: page,
            pageSize: pageSize
        });
        action.setCallback(this, (response) => {
            let state = response.getState();
            if(state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                this.setPaginationData(component, returnValue)
            } else {
                this.getNotificationHandler(component).handleActionError(response);
            }
        });
        $A.enqueueAction(action);
    },

    setPaginationData: function (component, returnValue) {
        component.set('v.products', returnValue.data);
        component.set('v.pageNumber', returnValue.page);
        component.set('v.pageSize', returnValue.pageSize);
        component.set('v.allProductsSize', returnValue.allProductsSize);
        this.setAllPageSize(component);
        this.hideSpinner(component);
    },

    getNotificationHandler: function(component) {
        return component.find('notificationHandler');
    }
})